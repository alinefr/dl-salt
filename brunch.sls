{% import "base.sls" as base with context %}

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
    - name: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - pkg: npm-deps

brunch:
  npm.installed:
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/node_modules
    - require:
      - npm: npm-install

bower:
  npm.installed:
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/node_modules
    - require:
      - npm: npm-install

bower-install:
  cmd.run:
    - name: {{ base.pre_args }}{{ base.www_root }}/node_modules/.bin/bower install --config.interactive=false
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install
      - sls: rvm

brunch-exec:
  cmd.run:
    - name: {{ base.pre_args }}{{ base.www_root }}/node_modules/.bin/brunch build {{ build_target }}
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require: 
      - npm: npm-install
      - sls: rvm

