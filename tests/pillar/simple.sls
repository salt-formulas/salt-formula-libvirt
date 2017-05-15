libvirt:
  server:
    enabled: true
    virtualizations:
    - kvm
    network:
      default:
        ensure: absent