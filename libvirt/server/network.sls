{% from "libvirt/map.jinja" import server with context %}
{%- if server.enabled %}


if pillar.libvirt.server.netcfg

{%- if server.netcfg is defined %}

/etc/libvirt/qemu/networks/default.xml:
  file.managed.absent:

{%- endif %}
