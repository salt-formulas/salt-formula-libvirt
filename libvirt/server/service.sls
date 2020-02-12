{% from "libvirt/map.jinja" import server with context %}
{%- if server.enabled %}

libvirt_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

{%- for virtualization in server.virtualizations %}

{%- if virtualization == 'kvm' %}

libvirt_kvm_packages:
  pkg.installed:
  - names: {{ server.kvm_pkgs }}

{%- endif %}

{%- endfor %}

libvirt_config:
  file.managed:
  - name: {{ server.config.file }}
  - source: salt://libvirt/files/libvirtd.conf
  - template: jinja
  - require:
    - pkg: libvirt_packages

{%- if grains.os_family == 'RedHat' %}

libvirt_sysconfig:
  file.managed:
  - name: {{ server.config_sys }}
  - contents: 'LIBVIRTD_ARGS="--listen"'
  - require:
    - pkg: libvirt_packages
  - watch_in:
    - service: libvirt_service

{%- elif grains.os_family == 'Debian' %}

libvirt_sysconfig:
  file.managed:
  - name: {{ server.config_sys }}
  - source: salt://libvirt/files/libvirt-bin
  - template: jinja
  - require:
    - pkg: libvirt_packages
  - watch_in:
    - service: libvirt_service
{%- if grains.get('init', None) == 'systemd' %}

libvirt_restart_systemd:
  module.wait:
  - name: service.systemctl_reload
  - watch:
    - file: libvirt_sysconfig
  - require_in:
    - service: libvirt_service

{%- endif %}

{%- endif %}

libvirt_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - watch:
    - file: libvirt_config

{%- endif %}
