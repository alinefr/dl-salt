{% set monit_mod_dir = '/etc/monit/conf.d' %}
{% set monit_mod_src = 'salt://base/monit_modules/files' %}
{% set monit_modules = [
  'nginx',
  'php5-fpm',
  'mysql-server',
  'postfix',
  'openssh-server'
] %}

{% for module in monit_modules %}
{% if salt['pkg.version'](module) %}
{{ monit_mod_dir }}/{{ module }}:
  file.managed:
    - source: {{ monit_mod_src }}/{{ module }}
{% endif %}
{% endfor %}


