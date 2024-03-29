{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set domain_name = salt['pillar.get']('domain_name','localhost') %}
{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}

{% if salt['cmd.run']('test -f ' ~ salt['pillar.get']('project_path','/vagrant') ~ '/Gemfile && echo "yes" || echo "no"') == 'yes' %}
include:
  - rvm
  {% set pre_args = '' ~ user_home ~ '/.rvm/bin/rvm 2.0.0@' ~ proj_name ~ ' do ' %}
{% else %}
  {% set pre_args = '' %}
{% endif %}

git:
  pkg.installed

git.config_set:
  module.run:
    - setting_name: url.https://.insteadOf
    - setting_value: git://
    - user: {{ user }}
    - is_global: True
    - require:
      - pkg: git


