{% from "libvirt/map.jinja" import server with context %}

{%- if server.enabled %}

libvirt_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

libvirtd_config:
  file.managed:
  - name: {{ server.config }}
  - source: salt://libvirt/files/libvirtd.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - pkg: libvirt_packages

libvirt_sysconfig:
  file.append:
  - name: {{ server.config_sys }}
  - text: 'LIBVIRTD_ARGS="--listen"'
  - require:
    - pkg: libvirt_packages

libvirt_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - reload: true
  - watch:
    - file: libvirtd_config

{%- endif %}