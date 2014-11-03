{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set mysql_user = proj_name|replace('-','')|truncate(15) %}
{% set mysql_db = mysql_user -%}

include:
  - mysql
  - rvm

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
    - require:
      - npm: npm-install

bower-install:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do rake bower:install
    - env: 
      - RAILS_ENV: production
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require:
      - npm: npm-install
      - sls: rvm

libmysqlclient-dev:
  pkg.installed

unicorn:
  gem.installed:
    - user: {{ user }}
    - ruby: 2.0.0@{{ proj_name }}

mysql2:
  gem.installed:
    - user: {{ user }}
    - ruby: 2.0.0@{{ proj_name }}
    - require:
      - pkg: libmysqlclient-dev

/run/unicorn:
  file.directory:
    - user: {{ user }}
    - makedirs: True

{{ www_root }}/log:
  file.directory:
    - user: {{ user }}
    - makedirs: True

{{ www_root }}/config/unicorn.conf.rb:
  file.managed:
    - source: 
      - salt://rails/unicorn.conf.rb
    - template: jinja

unicorn-wrapper:
  cmd.run:
    - name: rvm wrapper 2.0.0@{{ proj_name }} system unicorn_rails
    - user: {{ user }}
    - require:
      - gem: unicorn
    - unless: test -e {{ user_home }}/.rvm/bin/system_unicorn_rails

supervisor:
  pkg.installed

supervisor-conf:
  file.managed:
    - name: /etc/supervisor/conf.d/{{ proj_name }}.conf
    - source:
      - salt://rails/supervisor.conf
    - user: root
    - template: jinja
    - require:
      - pkg: supervisor

supervisor-service:
  supervisord.running:
    - name: {{ proj_name }}
    - require:
      - pkg: supervisor
      - file: supervisor-conf
    - watch:
      - file: supervisor-conf
    - restart: True

rails-dbconfig:
  file.managed:
    - name: {{ www_root }}/config/database.yml
    - source: salt://rails/database.yml
    - user: {{ user }}
    - template: jinja

rails-oauth:
  file.managed:
    - name: {{ www_root }}/config/initializers/omniauth.rb
    - source: salt://rails/omniauth.rb
    - user: {{ user }}
    - template: jinja

rails-assets:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do rake assets:precompile
    - user: {{ user }}
    - cwd: {{ www_root }}
    - env:
      - RAILS_ENV: production
    - require: 
      - supervisord: supervisor-service

rails-updatedb:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do rake db:migrate
    - user: {{ user }}
    - cwd: {{ www_root }}
    - env: 
      - RAILS_ENV: production
    - require:
      - supervisord: supervisor-service

