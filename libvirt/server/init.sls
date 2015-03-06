
include:
- libvirt.server.service
{% if pillar.libvirt.server.network != {}  %}
- libvirt.server.network
{% endif %}