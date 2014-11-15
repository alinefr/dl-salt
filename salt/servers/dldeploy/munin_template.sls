{% set www_root = '/var/cache/munin/www' %}
{% set user = 'munin' %}
{% set proj_name = 'munin' %}

{% if grains['os_family'] == 'Debian' %}
  {% set sites_enabled = "/etc/munin/sites-enabled" %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set sites_enabled = "/etc/munin/conf.d" %}
{% endif%}

include:
  - nginx

munin-conf:
  file.directory:
    - names:
      - {{ www_root }}
    - user: {{ user }}
    - makedirs: True
    - unless: test -d {{ www_root }}

munin-conf-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ proj_name }}.conf
    - source: salt://servers/dldeploy/munin_template.conf
    - template: jinja
    - context: 
      www_root: {{ www_root }}
      proj_name: {{ proj_name }}
    - watch_in:
      - service: nginx

munin-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ proj_name }}.conf
    - target: /etc/nginx/sites-available/{{ proj_name }}.conf
