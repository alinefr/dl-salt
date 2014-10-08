{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set proj_name = salt['pillar.get']('projname','myproject') %}

include:
  - nginx

{% if grains['os_family'] == 'Debian' %}
  {% set sites_enabled = "/etc/nginx/sites-enabled" %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set sites_enabled = "/etc/nginx/conf.d" %}
{% endif%}

nginx-conf:
  file.directory:
    - names:
      - {{ root }}
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True
    - unless: test -d {{ root }}

nginx-conf-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ proj_name }}.conf
    - source: salt://sites/template_common.conf
    - template: jinja
    - watch_in:
      - service: nginx
    - defaults:
        ssl: False

nginx-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ proj_name }}.conf
    - target: /etc/nginx/sites-available/{{ proj_name }}.conf
    - watch_in:
      - service: nginx
