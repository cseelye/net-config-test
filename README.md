# net-config-test
I built this container to try out network configuration methods - networkd, netplan, ip commands, IOCTL/netlink, etc.

The container will start up systemd-networkd and create a handful of dummy interfaces to play with. You can exec into it and create networkd configs, netplan files, C++ code, etc. Create or change the *.netdev files for more/less/different interfaces.

You can also run your favorite config on startup by volume mounting it into the container. For example:
```
-v $(pwd)/10-test-netplan.yaml:/etc/netplan/10-test-netplan.yaml
```

networkd is run with verbose logging; check journalctl for ouput.
```
journalctl -b -u systemd-networkd
```

## Privileges
You have two options for running the container - least privileged with capability SYS_ADMIN and a R/O volume mount of your cgroupfs, or fully privileged with --privileged. Note that --privileged gives the container R/W access to /sys including your host cgroups.
```
--cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro
```
At some point I might add a nested cgroupfs inside the container to make this better but for the moment it works well enough for me.
