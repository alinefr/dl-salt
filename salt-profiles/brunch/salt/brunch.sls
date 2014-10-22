{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
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
  module.run:
    - name: rvm.do
    - ruby: 2.0.0@{{ proj_name }}
    - command: {{ www_root }}/node_modules/.bin/bower install
    - runas: {{ user }}
    - cwd: {{ www_root }}
    - require:
      - npm: npm-install

brunch-exec:
  module.run:
    - name: rvm.do
    - ruby: 2.0.0@{{ proj_name }}
    - command: {{ www_root }}/node_modules/.bin/brunch build {{ build_target }}
    - runas: {{ user }}
    - cwd: {{ www_root }}
    - require: 
      - npm: npm-install

