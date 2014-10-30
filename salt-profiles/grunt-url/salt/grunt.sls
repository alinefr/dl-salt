{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% grains['host'] in ['gateway'] %}
  {% set env_target = 'production' %}
{% else %}
  {% set env_target = 'deploy' %}
{% endif %}
{% set grunt_arg = env_target + '://' + proj_name + '.' + grains['id'] %}

npm-deps:
  pkg.installed:
    - pkgs:
      - nodejs
      - nodejs-legacy
      - npm
      - phantomjs
      - graphicsmagick
      - libgif-dev

npm-install:
  npm.bootstrap: 
    - name: {{ www_root }}
    - user: {{ user }}
    - require:
      - pkg: npm-deps

grunt-cli:
  npm.installed:
    - user: {{ user }}
    - dir: {{ www_root }}/node_modules

grunt-exec:
  cmd.run:
    - name: {{ www_root }}/node_modules/.bin/grunt {{ grunt_arg }}
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require:
      - npm: npm-install

