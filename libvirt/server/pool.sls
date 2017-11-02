{%- from "libvirt/map.jinja" import server with context %}
{%- if server.pool is defined %}
{%- if server.enabled %}

include:
- libvirt.server.service

{%- for name, pool in server.pool.iteritems() %}

{%- set storage_config_file = '/etc/libvirt/storage' ~ '/' ~ name ~ '.xml' %}

{%- if pool.ensure|default('running') in ['present', 'running'] %}

{{ storage_config_file }}:
  file.managed:
  - makedirs: true
  - mode: 600
  - user: root
  - group: root
  - contents_pillar: libvirt:server:pool:{{ name }}:xml
  - require_in:
    - cmd: libvirt_virsh_pool_{{ name }}

libvirt_virsh_pool_{{ name }}:
  cmd.run:
  - name: virsh pool-define {{ storage_config_file }}
  - unless: virsh -q pool-list --all | grep -Eq '^\s*{{ name }}'
  - require:
    - pkg: libvirt_packages
    - service: libvirt_service

libvirt_virsh_pool_autostart_{{ name }}:
  cmd.run:
  - name: virsh pool-autostart {{ name }}
  - unless: virsh pool-info {{ name }} | grep -Eq '^Autostart:\s+yes'
  - require:
    - cmd: libvirt_virsh_pool_{{ name }}

libvirt_virsh_pool_startstop_{{ name }}:
  cmd.run:
  - name: virsh pool-start {{ name }}
  - unless: virsh -q pool-list --all | grep -Eq '^\s*{{ name }}\s+active'
  - require_in:
    - cmd: libvirt_virsh_pool_autostart_{{ name }}
{% endif %}
{% endfor %}
{% endif %}
{% else %}
debug_print:
  cmd.run:
    - name: "echo 'No pool is defined'"
{% endif %}
