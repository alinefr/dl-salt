{% set www_root = '/var/cache/munin/www' %}
{% set user = 'munin' %}
{% set proj_name = 'munin' %}

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
      - {{ www_root }}
    - user: {{ user }}
    - makedirs: True
    - unless: test -d {{ www_root }}

nginx-conf-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ proj_name }}.conf
    - source: salt://servers/dldeploy/munin_template.conf
    - template: jinja
    - context: 
      www_root: {{ www_root }}
      proj_name: {{ proj_name }}
    - watch_in:
      - service: nginx

nginx-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ proj_name }}.conf
    - target: /etc/nginx/sites-available/{{ proj_name }}.conf
    - watch_in:
      - service: nginx
