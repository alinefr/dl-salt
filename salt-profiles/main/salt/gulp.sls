{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}

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

bower:
  npm.installed:
    - user: {{ user }}
    - dir: {{ www_root }}/node_modules

bower-install:
  cmd.run:
    - name: {{ www_root }}/node_modules/.bin/bower install --config.interactive=false
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require:
      - npm: npm-install

gulp-exec:
  cmd.run:
    - name: {{ www_root }}/node_modules/.bin/gulp
    - name: "source ~{{ user }}/.rvm/scripts/rvm; rvm 2.0.0@{{ proj_name }} exec bundle exec ./node_modules/.bin/gulp"
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require:
      - sls: rvm
      - npm: npm-install

