libvirt:
  server:
    enabled: true
    unix_sock_group: libvirtd
    virtualizations:
    - kvm
    network:
      default:
        ensure: absent
