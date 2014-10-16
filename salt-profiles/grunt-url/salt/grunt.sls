{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% if ('ddll' in grains['host'] or 'staging' in grains['host']) %}
  {% set build_target = grains['host'] %}
  {% set env_target = 'deploy' %}
  {% set grunt_arg = env_target + '://' + proj_name + '-' + build_target + '.s3.amazonaws.com' %}
{% elif 'gateway' in grains['host'] %}
  {% set build_target = salt['pillar.get']('build_target','') %}
  {% set env_target = 'production' %}
  {% set grunt_arg = env_target + '://' + proj_name + '-' + build_target + '.s3.amazonaws.com' %}
{% else %}
  {% set grunt_arg = 'deploy' %}
{% endif %}

npm-deps:
  pkg.installed:
    - pkgs:
      - nodejs
      - nodejs-legacy
      - npm
      - phantomjs
      - graphicsmagick

npm-install:
  npm.bootstrap: 
    - names: 
      - {{ www_root }}
      - {{ www_root }}/mobile
    - user: {{ user }}
    - require:
      - pkg: npm-deps

grunt-cli:
  npm.installed:
    - user: {{ user }}
    - dir: {{ www_root }}/node_modules

grunt-cli-mobile:
  npm.installed:
    - name: grunt-cli
    - user: {{ user }}
    - dir: {{ www_root }}/mobile/node_modules

grunt-exec:
  cmd.run:
    - name: {{ www_root }}/node_modules/.bin/grunt {{ grunt_arg }}
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require:
      - npm: npm-install

grunt-exec-mobile:
  cmd.run:
    - name: {{ www_root }}/node_modules/.bin/grunt {{ grunt_arg }}/mobile
    - cwd: {{ www_root }}/mobile
    - user: {{ user }}
    - require:
      - npm: npm-install

