FROM ubuntu:20.04

# Install network tools and systemd
RUN apt-get update && \
    apt-get install --yes \
        iproute2 \
        netplan.io \
        systemd \
        udev \
        vim \
    && \
    apt-get --yes autoremove && apt-get --yes clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup systemd and networkd
RUN rm -f /usr/lib/systemd/system/multi-user.target.wants/getty.target \
    rm -f /usr/lib/systemd/system/getty.target.wants/getty-static.service \
    systemctl set-default multi-user.target && \
    systemctl enable systemd-networkd

# Put netdev file in place to create dummy interfaces on startup
COPY *.netdev /etc/systemd/network/
# Copy the netplan config into root's home so it is available but not run automatically
COPY *netplan.yaml /root/

# Run systemd on startup so we get networkd
ENV init /lib/systemd/systemd
ENTRYPOINT [ "/lib/systemd/systemd" ]
