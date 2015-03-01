
include:
{% if pillar.libvirt.server is defined %}
- libvirt.server
{% endif %}