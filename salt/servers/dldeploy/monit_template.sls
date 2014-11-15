{% set www_root = '/srv/www/open-m-monit' %}
{% set user = 'deploy' %}
{% set proj_name = 'monit' %}

include:
  - monit

{% if grains['os_family'] == 'Debian' %}
  {% set sites_enabled = "/etc/monin/sites-enabled" %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set sites_enabled = "/etc/monin/conf.d" %}
{% endif%}

monin-conf:
  file.directory:
    - names:
      - {{ www_root }}
    - user: {{ user }}
    - makedirs: True
    - unless: test -d {{ www_root }}

monin-conf-available:
  file.managed:
    - name: /etc/monin/sites-available/{{ proj_name }}.conf
    - source: salt://servers/dldeploy/munin_template.conf
    - template: jinja
    - context: 
      www_root: {{ www_root }}
      proj_name: {{ proj_name }}
    - watch_in:
      - service: monin

monin-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ proj_name }}.conf
    - target: /etc/monin/sites-available/{{ proj_name }}.conf
    - watch_in:
      - service: monit
