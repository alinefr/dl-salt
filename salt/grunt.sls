{% import "base.sls" as base with context %}

{% if ('ddll' in grains['host'] or 'staging' in grains['host']) %}
  {% set build_target = grains['host'] %}
  {% set env_target = 'deploy' %}
  {% set grunt_arg = env_target + '://' + base.proj_name + '-' + build_target + '.s3.amazonaws.com' %}
{% elif 'gateway' in grains['host'] %}
  {% set build_target = salt['pillar.get']('build_target','') %}
  {% set env_target = 'production' %}
  {% set grunt_arg = env_target + '://' + base.proj_name + '-' + build_target + '.s3.amazonaws.com' %}
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
      - {{ base.www_root }}
      - {{ base.www_root }}/mobile
    - user: {{ base.user }}
    - require:
      - pkg: npm-deps

grunt-cli:
  npm.installed:
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/node_modules

grunt-cli-mobile:
  npm.installed:
    - name: grunt-cli
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/mobile/node_modules

grunt-exec:
  cmd.run:
    - name: {{ base.www_root }}/node_modules/.bin/grunt {{ grunt_arg }}
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install

grunt-exec-mobile:
  cmd.run:
    - name: {{ base.www_root }}/node_modules/.bin/grunt {{ grunt_arg }}/mobile
    - cwd: {{ base.www_root }}/mobile
    - user: {{ base.user }}
    - require:
      - npm: npm-install

