{% set root = salt['pillar.get']('project_path','/srv/www') %}
{% set user = salt['pillar.get']('project_username','deploy') %}

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
    - name: /etc/nginx/sites-available/{{ salt['pillar.get']('project_name') }}.conf
    - source: salt://sites/template_common.conf
    - template: jinja
    - watch_in:
      - service: nginx
    - defaults:
        ssl: False

nginx-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ salt['pillar.get']('project_name') }}.conf
    - target: /etc/nginx/sites-available/{{ salt['pillar.get']('project_name') }}.conf
    - watch_in:
      - service: nginx
