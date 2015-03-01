
{%- if pillar.kvm.hostnode.enabled %}

kvm_packages:
  pkg.installed:
  - names:
    - qemu-kvm
    - libvirt-bin
    - ubuntu-vm-builder
    - bridge-utils

kvm_dir:
  file.directory:
  - name: /srv/kvm
  - user: root
  - group: root
  - mode: 775

{%- endif %}