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
      - {{ pillar['root'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - makedirs: True
    - unless: test -d {{ pillar['root'] }}/{{ salt['pillar.get']('project_name') }}

nginx-conf-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ salt['pillar.get']('domain_name') }}.conf
    - source: salt://sites/template.conf
    - template: jinja
    - watch_in:
      - service: nginx
    - defaults:
        ssl: False

nginx-conf-enabled:
  file.symlink:
    - name: {{ sites_enabled }}/{{ salt['pillar.get']('domain_name') }}.conf
    - target: /etc/nginx/sites-available/{{ salt['pillar.get']('domain_name') }}.conf
    - watch_in:
      - service: nginx
