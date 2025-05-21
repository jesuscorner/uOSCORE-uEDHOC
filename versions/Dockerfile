# Base image
FROM debian:12-slim

# Actualización del sistema y limpieza en un solo paso
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    vim \
    iputils-ping \
    rsyslog \
    tcpdump \
    net-tools \
    procps \
    git \
    make \
    gcc \
    g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Establecer el comando por defecto
CMD ["tail", "-f", "/dev/null"]
