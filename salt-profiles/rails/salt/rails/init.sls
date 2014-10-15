{% set user = salt['pillar.get']('project_username','vagrant') %}
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

unicorn-wrapper:
  module.run:
    - name: rvm.wrapper
    - ruby_string: 2.0.0@google-googlelab
    - wrapper_prefix: system
    - binaries: [unicorn_rails]
    - runas: deploy

supervisor-conf:
  file.managed:
    - name: /etc/supervisor/conf.d/{{ proj_name }}.conf
    - source:
      - salt://rails/supervisor.conf
    - user: root
    - template: jinja

supervisor:
  pkg:
    - installed

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

rails-assets:
  module.run:
    - name: rvm.do
    - ruby: 2.0.0@{{ proj_name }}
    - command: RAILS_ENV=production rake assets:precompile
    - runas: {{ user }}
    - cwd: {{ www_root }}
    - require: 
      - sls: rvm

rails-updatedb:
  module.run:
    - name: rvm.do
    - ruby: 2.0.0@{{ proj_name }}
    - command: RAILS_ENV=production rake db:migrate
    - runas: {{ user }}
    - cwd: {{ www_root }}
    - require:
      - sls: rvm 

