{% import "base.sls" as base with context %}

include:
  - mysql
  - rvm

/run/unicorn:
  file.directory:
    - user: {{ base.user }}
    - makedirs: True

{{ www_root }}/log:
  file.directory:
    - user: {{ base.user }}
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
    - user: {{ base.user }}
    - ruby: 2.0.0@{{ base.proj_name }}

  cmd.run:
    - name: rvm wrapper 2.0.0@{{ base.proj_name }} system unicorn_rails
    - user: {{ base.user }}
    - require:
      - gem: unicorn
    - unless: test -e {{ base.user_home }}/.rvm/bin/system_unicorn_rails

  file.managed:
    - name: /etc/supervisor/conf.d/{{ base.proj_name }}.conf
    - source:
      - salt://rails/supervisor.conf
    - user: root
    - template: jinja
    - require:
      - pkg: supervisor

  supervisord.running:
    - name: {{ base.proj_name }}
    - require:
      - pkg: supervisor
      - file: unicorn
    - watch:
      - file: unicorn
    - restart: True

rails-dbconfig:
  file.managed:
    - name: {{ base.www_root }}/config/database.yml
    - source: salt://rails/database.yml
    - user: {{ user }}
    - template: jinja

rails-assets:
  cmd.run:
    - name: {{ base.user_home }}/.rvm/bin/rvm 2.0.0@{{ base.proj_name }} do bundle exec rake assets:precompile
    - user: {{ base.user }}
    - cwd: {{ base.www_root }}
    - env:
      - RAILS_ENV: production
    - watch_in: 
      - supervisord: unicorn

rails-updatedb:
  cmd.run:
    - name: {{ base.user_home }}/.rvm/bin/rvm 2.0.0@{{ base.proj_name }} do bundle exec rake db:migrate
    - user: {{ base.user }}
    - cwd: {{ base.www_root }}
    - env: 
      - RAILS_ENV: production
    - watch_in:
      - supervisord: unicorn

