#!/bin/bash
# EDHOC Test CSV Generator
# This script runs multiple EDHOC exchanges between initiator and responder in Docker containers
# and collects metrics in a CSV file

# Configuration
NUM_RUNS=100
CSV_FILE="edhoc_results.csv"
DOCKER_NETWORK="edhoc_network"
RESPONDER_CONTAINER="edhoc-responder-1"
INITIATOR_CONTAINER="edhoc-initiator-1"

# Function to clean up when the script exits
cleanup() {
    echo "Cleaning up Docker containers..."
    docker stop $RESPONDER_CONTAINER 2>/dev/null
    docker rm $RESPONDER_CONTAINER 2>/dev/null
    docker stop $INITIATOR_CONTAINER 2>/dev/null
    docker rm $INITIATOR_CONTAINER 2>/dev/null
    docker network rm $DOCKER_NETWORK 2>/dev/null
    exit 0
}

# Function to start packet capture on the host instead of inside container
start_packet_capture() {
    echo "Starting packet capture on host machine..."
    
    # Install tcpdump if needed
    if ! command -v tcpdump &> /dev/null; then
        echo "Installing tcpdump on host..."
        sudo apt-get update && sudo apt-get install -y tcpdump
    fi
    
    
    # Run tcpdump on host
    echo "Starting tcpdump to capture UDP traffic between containers on port 5683..."
    DOCKER_IFACE="any" 
    sudo tcpdump -i $DOCKER_IFACE -n -w ./edhoc_capture.pcap &
    TCPDUMP_PID=$!
    
    # Save PID to variable and file for easier termination
    echo $TCPDUMP_PID > /tmp/edhoc_tcpdump_pid
    echo "Packet capture started on host with PID: $TCPDUMP_PID"
    
    # Wait to ensure capture is ready
    sleep 3
}

# Function to stop packet capture
stop_packet_capture() {
    echo "Stopping packet capture on host machine..."
    
    # Stop tcpdump process on host
    sudo pkill tcpdump 2>/dev/null || true
    sleep 2
    
    # Check if capture file has data
    PCAP_SIZE=$(stat -c%s "edhoc_capture.pcap" 2>/dev/null || echo "0")
    if [ "$PCAP_SIZE" -gt "100" ]; then
        echo "Packet capture successful. File size: $PCAP_SIZE bytes"
    else
        echo "Warning: Packet capture file is small or empty. No packets may have been captured."
    fi
}


# Set up trap to catch Ctrl+C and other termination signals
trap cleanup SIGINT SIGTERM EXIT

# Create CSV header
echo "Run,M1_total_size,M2_total_size,M3_total_size,M4_total_size,M1_gen_time,M2_gen_time,M3_gen_time,M4_gen_time,Total_Exchange_time,Method" > $CSV_FILE

# Check Docker and docker-compose availability
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed or not in the PATH"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo "Error: docker compose is not installed or not in the PATH"
    exit 1
fi

# Start responder container
echo "Starting containers..."
docker compose up -d
sleep 5  

# Check if the containers are running
if ! docker ps | grep -q $RESPONDER_CONTAINER; then
    echo "Error: Responder container $RESPONDER_CONTAINER is not running!"
    exit 1
fi

if ! docker ps | grep -q $INITIATOR_CONTAINER; then
    echo "Error: Initiator container $INITIATOR_CONTAINER is not running!"
    exit 1
fi

# Give responder time to start - don't use -it flags which require TTY
echo "Starting responder service in container..."
docker exec $RESPONDER_CONTAINER bash -c "cd /tmp/tiempos/samples/linux_edhoc/responder/ && make clean && make && ./build/responder" &
RESPONDER_PID=$!

echo "Responder initialized at IP $RESPONDER_IP..."

echo "Building initiator..."
docker exec $INITIATOR_CONTAINER bash -c "cd /tmp/tiempos/samples/linux_edhoc/initiator/ && make clean && make"
echo "Initiator prepared."

# Loop to run initiator multiple times
for ((i=1; i<=$NUM_RUNS; i++)); do
    echo "Running test $i of $NUM_RUNS..."
    
    # Start packet capture for the first run only
    if [ $NUM_RUNS -eq 1 ]; then
        start_packet_capture
    fi
    
    # Run initiator in the initiator container
    echo "Executing initiator in container $INITIATOR_CONTAINER..."
    FULL_OUTPUT=$(docker exec $INITIATOR_CONTAINER bash -c "cd /tmp/tiempos/samples/linux_edhoc/initiator/ && ./build/initiator 2>&1")
    
    if [ $NUM_RUNS -eq 1 ]; then
        stop_packet_capture
    fi
    
    # Extract CSV metrics from output
    RUN_RESULT=$(echo "$FULL_OUTPUT" | grep -E 'CSV_OUTPUT')
    
    if [ -n "$RUN_RESULT" ]; then
        # Format: CSV_OUTPUT:M1_size,M2_size,M3_size,M4_size,M1_time,M2_time,M3_time,M4_time,Total_time
        METRICS=$(echo $RUN_RESULT | sed 's/CSV_OUTPUT://g')
        echo "$i,$METRICS" >> $CSV_FILE
        echo "✓ Success - Data captured"
        
        # Print the captured metrics for confirmation
        echo "   Metrics: $METRICS"
    else
        echo "$i,,,,,,,,," >> $CSV_FILE  # Empty fields for failed run
        echo "✗ Failed (no metrics data)"
    fi
    
    # Short pause between runs
    sleep 1
done

# Tests are now complete
echo "All tests completed successfully!"
echo "Results saved to $CSV_FILE"

# Generate more detailed statistics
if [ -f "$CSV_FILE" ]; then
    TOTAL_LINES=$(wc -l < "$CSV_FILE")
    DATA_LINES=$((TOTAL_LINES - 1))  # Subtract header line
    
    # Only calculate statistics if we have data
    if [ $DATA_LINES -gt 0 ]; then
        echo ""
        echo "EDHOC Performance Statistics:"
        echo "============================="
        echo "Total runs: $DATA_LINES"
        
        # Count successful runs (rows with data)
        SUCCESSFUL_RUNS=$(grep -v "^Run\|^[0-9]\+,,,,,,,,," "$CSV_FILE" | wc -l)
        echo "Successful runs: $SUCCESSFUL_RUNS"
        
        if [ $SUCCESSFUL_RUNS -gt 0 ]; then
            # Calculate statistics for multiple columns
            echo ""
            echo "Message Size Statistics (bytes):"
            echo "-----------------------------"
            # M1 size
            AVG_M1_SIZE=$(awk -F, 'NR>1 && $2!="" {sum+=$2; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' "$CSV_FILE")
            # M2 size
            AVG_M2_SIZE=$(awk -F, 'NR>1 && $3!="" {sum+=$3; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' "$CSV_FILE")
            # M3 size
            AVG_M3_SIZE=$(awk -F, 'NR>1 && $4!="" {sum+=$4; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' "$CSV_FILE")
            # M4 size
            AVG_M4_SIZE=$(awk -F, 'NR>1 && $5!="" {sum+=$5; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' "$CSV_FILE")
            
            echo "Average M1 size: $AVG_M1_SIZE bytes"
            echo "Average M2 size: $AVG_M2_SIZE bytes"
            echo "Average M3 size: $AVG_M3_SIZE bytes"
            echo "Average M4 size: $AVG_M4_SIZE bytes"
            
            echo ""
            echo "Message Generation Time Statistics (ms):"
            echo "------------------------------------"
            # M1 time
            AVG_M1_TIME=$(awk -F, 'NR>1 && $6!="" {sum+=$6; count++} END {if(count>0) printf "%.3f", sum/count; else print "N/A"}' "$CSV_FILE")
            # M2 time
            AVG_M2_TIME=$(awk -F, 'NR>1 && $7!="" {sum+=$7; count++} END {if(count>0) printf "%.3f", sum/count; else print "N/A"}' "$CSV_FILE")
            # M3 time
            AVG_M3_TIME=$(awk -F, 'NR>1 && $8!="" {sum+=$8; count++} END {if(count>0) printf "%.3f", sum/count; else print "N/A"}' "$CSV_FILE")
            # M4 time
            AVG_M4_TIME=$(awk -F, 'NR>1 && $9!="" {sum+=$9; count++} END {if(count>0) printf "%.3f", sum/count; else print "N/A"}' "$CSV_FILE")
            
            echo "Average M1 generation time: $AVG_M1_TIME ms"
            echo "Average M2 generation time: $AVG_M2_TIME ms"
            echo "Average M3 generation time: $AVG_M3_TIME ms"
            echo "Average M4 generation time: $AVG_M4_TIME ms"
            
            echo ""
            echo "Total Exchange Time:"
            echo "------------------"
            # Total time
            AVG_TOTAL_TIME=$(awk -F, 'NR>1 && $10!="" {sum+=$10; count++} END {if(count>0) printf "%.3f", sum/count; else print "N/A"}' "$CSV_FILE")
            MIN_TOTAL_TIME=$(awk -F, 'NR>1 && $10!="" {if(min=="" || $10<min) min=$10} END {if(min!="") print min; else print "N/A"}' "$CSV_FILE")
            MAX_TOTAL_TIME=$(awk -F, 'NR>1 && $10!="" {if($10>max) max=$10} END {if(max!="") print max; else print "N/A"}' "$CSV_FILE")
            
            echo "Average exchange time: $AVG_TOTAL_TIME ms"
            echo "Minimum exchange time: $MIN_TOTAL_TIME ms"
            echo "Maximum exchange time: $MAX_TOTAL_TIME ms"
            
            # Calculate M3's percentage of total time (likely the most time-consuming part)
            if [ "$AVG_M3_TIME" != "N/A" ] && [ "$AVG_TOTAL_TIME" != "N/A" ]; then
                M3_PERCENTAGE=$(awk -v m3="$AVG_M3_TIME" -v total="$AVG_TOTAL_TIME" 'BEGIN {printf "%.1f", (m3/total)*100}')
                echo ""
                echo "M3 represents approximately $M3_PERCENTAGE% of the total exchange time"
                echo "(This is expected due to the intensive cryptographic operations in M3)"
            fi
            
            echo ""
            echo "Capture Information:"
            echo "------------------"
            if [ -f "./edhoc_capture.pcap" ]; then
                PCAP_SIZE=$(stat -c%s "edhoc_capture.pcap" 2>/dev/null || echo "0")
                echo "Traffic capture file size: $PCAP_SIZE bytes"
                if [ "$PCAP_SIZE" -gt "100" ]; then
                    # Count packets in the capture file
                    if command -v tshark &> /dev/null; then
                        PACKET_COUNT=$(tshark -r edhoc_capture.pcap 2>/dev/null | wc -l)
                        echo "Number of packets captured: $PACKET_COUNT"
                    else
                        echo "Install Wireshark/tshark to analyze the capture file in detail"
                    fi
                else
                    echo "WARNING: Capture file appears to be empty or contains very little data."
                fi
            else
                echo "No packet capture file found."
            fi
        fi
    fi
fi
