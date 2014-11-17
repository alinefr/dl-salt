{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}

include:
  - mysql
  - rvm

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

supervisor:
  pkg.installed

unicorn:
  gem.installed:
    - user: {{ user }}
    - ruby: 2.0.0@{{ proj_name }}

  cmd.run:
    - name: rvm wrapper 2.0.0@{{ proj_name }} system unicorn_rails
    - user: {{ user }}
    - require:
      - gem: unicorn
    - unless: test -e {{ user_home }}/.rvm/bin/system_unicorn_rails

  file.managed:
    - name: /etc/supervisor/conf.d/{{ proj_name }}.conf
    - source:
      - salt://rails/supervisor.conf
    - user: root
    - template: jinja
    - require:
      - pkg: supervisor

  supervisord.running:
    - name: {{ proj_name }}
    - require:
      - pkg: supervisor
      - file: unicorn
    - watch:
      - file: unicorn
    - restart: True

rails-dbconfig:
  file.managed:
    - name: {{ www_root }}/config/database.yml
    - source: salt://rails/database.yml
    - user: {{ user }}
    - template: jinja

rails-assets:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do bundle exec rake assets:precompile
    - user: {{ user }}
    - cwd: {{ www_root }}
    - env:
      - RAILS_ENV: production
    - watch_in: 
      - supervisord: unicorn

rails-updatedb:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do bundle exec rake db:migrate
    - user: {{ user }}
    - cwd: {{ www_root }}
    - env: 
      - RAILS_ENV: production
    - watch_in:
      - supervisord: unicorn

