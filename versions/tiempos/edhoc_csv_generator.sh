#!/bin/bash
# EDHOC Test CSV Generator

# Configuration
NUM_RUNS=100
CSV_FILE="edhoc_results.csv"
DOCKER_NETWORK="edhoc_network"
RESPONDER_CONTAINER="edhoc-responder-1"
INITIATOR_CONTAINER="edhoc-initiator-1"

# Function to clean up when the script exits
cleanup() {
    docker stop $RESPONDER_CONTAINER 2>/dev/null
    docker rm $RESPONDER_CONTAINER 2>/dev/null
    docker stop $INITIATOR_CONTAINER 2>/dev/null
    docker rm $INITIATOR_CONTAINER 2>/dev/null
    docker network rm $DOCKER_NETWORK 2>/dev/null
    exit 0
}

# Function to start packet capture in the initiator container
start_packet_capture() {
  local pcap_file="/tmp/tiempos/m.pcap"
  local log_file="/tmp/tiempos/tcpdump.log"
  local pid_file="/tmp/tiempos/tcpdump.pid"

  # Command to be executed inside the container
  # -U: packet-buffered output.
  # -Z root: drop privileges after opening capture device.
  # -vvv: verbose output (for logs).
  # The filter is single-quoted.
  # stderr of tcpdump appends to log_file (after initial echo).
  # PID of tcpdump background process is saved to pid_file.
  local inner_cmd="mkdir -p /tmp/tiempos && \\
    rm -f '${pcap_file}' '${log_file}' '${pid_file}' && \\
    tcpdump -U -Z root -i eth0 ip and udp port 5683 and \( host 192.168.56.101 or host 192.168.56.102 \) -w '${pcap_file}' 2>> '${log_file}' & echo \\$! > '${pid_file}'"

  echo "Attempting to start tcpdump in ${INITIATOR_CONTAINER}..."
  sudo docker exec "${INITIATOR_CONTAINER}" bash -c "${inner_cmd}"

  if [ $? -ne 0 ]; then
    sudo docker cp "${INITIATOR_CONTAINER}:${log_file}" "./tcpdump_initiator_stderr_start_failure.log" 2>/dev/null
    exit 1
  fi

  # Verify PID file creation and content after a short delay
  sleep 1 # Give a moment for PID file to be written
  local pid_check_cmd="cat '${pid_file}'"
  local captured_pid=$(sudo docker exec "${INITIATOR_CONTAINER}" bash -c "${pid_check_cmd}" 2>/dev/null)

  if [[ -n "$captured_pid" && "$captured_pid" -gt 0 ]]; then
    echo "Tcpdump started in container with PID ${captured_pid} (according to ${pid_file})."
  else
    sudo docker cp "${INITIATOR_CONTAINER}:${log_file}" "./tcpdump_initiator_stderr.log" 2>/dev/null
    # This could be a fatal error, but script will continue with a warning for now.
  fi
  sleep 4 # Total sleep of 5s after exec command.
}

# Function to stop packet capture
stop_packet_capture() {
    local pcap_file="/tmp/tiempos/m.pcap"
    local log_file="/tmp/tiempos/tcpdump.log"
    local pid_file="/tmp/tiempos/tcpdump.pid"
    local host_pcap_file="./edhoc_capture.pcap"
    local host_log_file="./tcpdump_initiator_stderr.log"

    # Command to read PID and send SIGINT
    # Fallback to pkill if PID file is not found or empty.
    local stop_cmd="if [ -s '${pid_file}' ]; then \\
                      TARGET_PID=\\$(cat '${pid_file}'); \\
                      echo 'Found PID \${TARGET_PID} in ${pid_file}. Sending SIGINT...'; \\
                      kill -SIGINT \${TARGET_PID}; \\
                      rm -f '${pid_file}'; \\
                      echo 'SIGINT sent to PID \${TARGET_PID}.'; \\
                    else \\
                      echo 'WARNING: PID file ${pid_file} not found or empty. Trying pkill -f tcpdump as fallback.'; \\
                      pkill -SIGINT -f 'tcpdump -i eth0.*-w ${pcap_file}'; \\
                    fi"
    
    sudo docker exec "$INITIATOR_CONTAINER" bash -c "${stop_cmd}"
    
    if [ $? -ne 0 ]; then
        # This checks the exit status of 'docker exec', not necessarily if kill/pkill succeeded.
        echo "WARNING: Docker exec command to stop tcpdump finished with non-zero status. Check container if issues persist."
    fi

    echo "Waiting for tcpdump to flush buffers and write to file (3 seconds)..."
    sleep 3

    echo "Copying tcpdump log from ${INITIATOR_CONTAINER}:${log_file} to ${host_log_file}..."
    sudo docker cp "$INITIATOR_CONTAINER:${log_file}" "${host_log_file}"
    if [ $? -ne 0 ]; then
        echo "WARNING: Failed to copy tcpdump log from container."
    else
        echo "Tcpdump log copied."
    fi

    echo "Copying pcap file from ${INITIATOR_CONTAINER}:${pcap_file} to ${host_pcap_file}..."
    sudo docker cp "$INITIATOR_CONTAINER:${pcap_file}" "${host_pcap_file}"
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to copy pcap file from container."
    else
        echo "Pcap file copied to ${host_pcap_file}."
        local actual_size=$(stat -c%s "${host_pcap_file}" 2>/dev/null || echo "0")
        echo "Size of ${host_pcap_file} on host: ${actual_size} bytes."
        if [ "${actual_size}" -lt "100" ]; then # Min pcap header is 24 bytes. 100 bytes suggests at least some packets.
             echo "WARNING: Copied pcap file is very small (${actual_size} bytes). Capture might be empty or incomplete."
        fi
    fi
}

# Set up trap to catch Ctrl+C and other termination signals
trap cleanup SIGINT SIGTERM EXIT

# Create CSV header
echo "Run,M1_total_size,M2_total_size,M3_total_size,M4_total_size,M1_gen_time,M2_gen_time,M3_gen_time,M4_gen_time,Total_Exchange_time,Method" > $CSV_FILE

# Start responder container
docker compose up -d
sleep 3

# Check if the containers are running
if ! docker ps | grep -q $RESPONDER_CONTAINER; then
    echo "Error: Responder container $RESPONDER_CONTAINER is not running!"
    exit 1
fi

if ! docker ps | grep -q $INITIATOR_CONTAINER; then
    echo "Error: Initiator container $INITIATOR_CONTAINER is not running!"
    exit 1
fi

# Start responder service
RESPONDER_LOG_IN_CONTAINER="/tmp/tiempos/responder_exec.log"
docker exec $RESPONDER_CONTAINER bash -c "cd /tmp/tiempos/samples/linux_edhoc/responder/ && make clean && make && ./build/responder > '${RESPONDER_LOG_IN_CONTAINER}' 2>&1" &
RESPONDER_PID=$!

# Build initiator
docker exec $INITIATOR_CONTAINER bash -c "cd /tmp/tiempos/samples/linux_edhoc/initiator/ && make clean && make"

# Loop to run initiator multiple times
for ((i=1; i<=$NUM_RUNS; i++)); do
    # Start packet capture for the first run only
    if [ "$NUM_RUNS" -eq 1 ]; then
        start_packet_capture
    fi
    
    INITIATOR_LOG_FILE="./mx_initiator_run.log"
    RESPONDER_LOG_FILE="./mx_responder_run.log"

    FULL_OUTPUT=$(sudo docker exec $INITIATOR_CONTAINER bash -c "cd /tmp/tiempos/samples/linux_edhoc/initiator/ && ./build/initiator 2>&1")
    
    if [ "$NUM_RUNS" -eq 1 ]; then
        echo "$FULL_OUTPUT" > "$INITIATOR_LOG_FILE"
        # Copy responder log from the file inside the container
        sudo docker cp "${RESPONDER_CONTAINER}:${RESPONDER_LOG_IN_CONTAINER}" "${RESPONDER_LOG_FILE}"
        # Fallback or append docker logs if needed, though the file should be primary
        # sudo docker logs $RESPONDER_CONTAINER >> "$RESPONDER_LOG_FILE" 2>&1 
    fi

    if [ "$NUM_RUNS" -eq 1 ]; then
        stop_packet_capture
    fi
    
    # Extract CSV metrics from output
    RUN_RESULT=$(echo "$FULL_OUTPUT" | grep -E 'CSV_OUTPUT')
    
    if [ -n "$RUN_RESULT" ]; then
        # Format: CSV_OUTPUT:M1_size,M2_size,M3_size,M4_size,M1_time,M2_time,M3_time,M4_time,Total_time
        METRICS=$(echo $RUN_RESULT | sed 's/CSV_OUTPUT://g')
        echo "$i,$METRICS" >> $CSV_FILE
    else
        echo "$i,,,,,,,,," >> $CSV_FILE  # Empty fields for failed run
    fi
    
    sleep 1
done

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
