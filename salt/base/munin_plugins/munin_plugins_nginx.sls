{% set proj_name = 'localhost' %}

include:
  - nginx

{% if grains['os_family'] == 'Debian' %}
  {% set sites_enabled = "/etc/nginx/sites-enabled" %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set sites_enabled = "/etc/nginx/conf.d" %}
{% endif%}

nginx-conf-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ proj_name }}.conf
    - source: salt://base/munin_plugins_nginx.conf
    - template: jinja
    - context: 
      proj_name: {{ proj_name }}
    - watch_in:
      - service: nginx

nginx-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ proj_name }}.conf
    - target: /etc/nginx/sites-available/{{ proj_name }}.conf
    - watch_in:
      - service: nginx
