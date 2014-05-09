include:
  - nginx

{% if grains['os_family'] == 'Debian' %}
  {% set sites_enabled = "/etc/nginx/sites-enabled" %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set sites_enabled = "/etc/nginx/conf.d" %}
{% endif%}

vagrant:
  file.directory:
    - names:
      - {{ pillar['root'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - makedirs: True
    - unless: test -d {{ pillar['root'] }}

vagrant-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ pillar['server_name'] }}.conf
    - source: salt://sites/template.conf
    - template: jinja
    - watch_in:
      - service: nginx
    - defaults:
        ssl: False

vagrant-nginx-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ pillar['server_name'] }}.conf
    - target: /etc/nginx/sites-available/{{ pillar['server_name'] }}.conf
    - watch_in:
      - service: nginx
