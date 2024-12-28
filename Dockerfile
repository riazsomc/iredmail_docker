# Use a lightweight base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    IREDMAIL_VERSION=1.7.1

# Update system and install minimal prerequisites for iRedMail installer
RUN apt-get update && apt-get install -y \
    wget gzip dialog tar && \
    apt-get clean

# Download and extract iRedMail
WORKDIR /root
RUN wget https://github.com/iredmail/iRedMail/archive/refs/tags/${IREDMAIL_VERSION}.tar.gz && \
    tar -xzf ${IREDMAIL_VERSION}.tar.gz && \
    rm ${IREDMAIL_VERSION}.tar.gz

# Switch to iRedMail directory
WORKDIR /root/iRedMail-${IREDMAIL_VERSION}

# Copy Supervisor configuration for managing services (optional if needed)
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Expose necessary ports
EXPOSE 25 143 993 465 587 110 995 8080

# Start Supervisor as the entry point
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
