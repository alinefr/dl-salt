{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set rubygems = salt['pillar.get']('rubygems',False) %}
{% if rubygems == True %}
  {% set pre_arg = '' ~ user_home ~ '/.rvm/bin/rvm 2.0.0@' ~ proj_name ~ ' do' %}
  include:
    - rvm
{% else %}
  {% set pre_arg = '' %}
{% endif %}
{% if grains['host'] in ['ddll','staging','gateway'] %}
  {% set build_target = '--production' %}
{% else %}
  {% set build_target = '' %}
{% endif %}

npm-deps:
  pkg.installed:
    - pkgs:
      - nodejs
      - nodejs-legacy
      - npm

npm-install:
  npm.bootstrap: 
    - name: {{ www_root }}
    - user: {{ user }}
    - require:
      - pkg: npm-deps

brunch:
  npm.installed:
    - user: {{ user }}
    - dir: {{ www_root }}/node_modules
    - require:
      - npm: npm-install

bower:
  npm.installed:
    - user: {{ user }}
    - dir: {{ www_root }}/node_modules
    - require:
      - npm: npm-install

bower-install:
  cmd.run:
    - name: {{ pre_arg }} {{ www_root }}/node_modules/.bin/bower install --config.interactive=false
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require:
      - npm: npm-install
      - sls: rvm

brunch-exec:
  cmd.run:
    - name: {{ pre_arg }} {{ www_root }}/node_modules/.bin/brunch build {{ build_target }}
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require: 
      - npm: npm-install
      - sls: rvm

