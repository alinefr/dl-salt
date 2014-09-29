{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}

/run/unicorn:
  file.directory:
    - user: {{ user }}
    - makedirs: True

{{ root }}/log:
  file.directory:
    - user: {{ user }}
    - makedirs: True

{{ root }}/config/unicorn.conf.rb:
  file.managed:
    - source: 
      - salt://rails/unicorn.conf.rb
    - template: jinja

unicorn-wrapper:
  cmd.run:
    - name: ~/.rvm/bin/rvm wrapper {{ salt['cmd.run']('~' ~ user ~ '/.rvm/bin/rvm current',user=user) }}@{{ proj_name }} system unicorn_rails
    - unless: test -f ~{{ user }}/.rvm/bin/system_unicorn_rails
    - env:
      - RAILS_ENV: 'production'
    - user: {{ user }}
    - require:  
      - sls: rvm

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

