{%- from "libvirt/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- libvirt.server.service

{%- for name, network server:networks.iteritems() %}

{%- set network_config_file = '/etc/libvirt/qemu/networks' ~ '/' ~ name ~ '.xml' %}

{%- if network.ensure|default('running') in ['present', 'running'] %}

{{ network_config_file }}:
  file.managed:
  - mode: 600
  - user: root
  - group: root
  - contents_pillar: libvirt:networks:{{ name }}:xml
  - watch_in:
    - service: libvirt_service

net-{{ name }}:
  cmd.run:
  - name: virsh net-define {{ network_config_file }}
  - unless: virsh -q net-list --all | grep -q '^{{ name }}'

{%- if network.autostart|default(True) %}

net-autostart-{{ name }}:
  cmd.run:
  - name: virsh net-autostart {{ name }}
  - unless: virsh net-info {{ name }} | grep -Eq '^Autostart:\s+yes'

{%- endif %}

net-startstop-{{ name }}:
  cmd.run:
  - name: virsh net-start {{ name }}
  - unless: virsh -q net-list --all | grep -Eq '^{{ name }}\s+active'

{%- elif network.ensure|default('running') == 'absent' %}

{{ network_config_file }}:
  file.absent:
  - watch_in:
    - service: libvirt_service

net-{{ name }}:
  cmd.run:
  - name: virsh net-destroy {{ name }} 2>&1 1>/dev/null; virsh net-undefine {{ name }}
  - onlyif: virsh -q net-list --all | grep -q '^{{ name }}'

net-autostart-{{ name }}:
  cmd.run:
  - name: virsh net-autostart {{ name }} --disable
  - onlyif: virsh net-info {{ name }} | grep -Eq '^Autostart:\s+yes'

net-startstop-{{ name }}:
  cmd.run:
  - name: virsh net-destroy {{ name }}
  - onlyif: virsh -q net-list --all | grep -Eq '^{{ name }}\s+active'

{%- endif %}

{%- endfor %}

{%- endif %}
