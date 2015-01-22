{% import "base.sls" as base with context %}
{% set grunt_arg = 'build' %}

npm-deps:
  pkg.installed:
    - pkgs:
      - nodejs
      - nodejs-legacy
      - npm

npm-install:
  npm.bootstrap: 
    - names: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - pkg: npm-deps

grunt-cli:
  npm.installed:
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/node_modules
    - require:
      - npm: npm-install

grunt-exec:
  cmd.run:
    - name: {{ base.www_root }}/node_modules/.bin/grunt {{ grunt_arg }}
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install
