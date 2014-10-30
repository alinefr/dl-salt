{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}

ruby-2.0.0:
  rvm.installed
    - default: True
    - runas: {{ user }}

{{ proj_name }}:
  rvm:
    - gemset_present
    - ruby: ruby-2.0.0
    - runas: {{ user }}
    - require:
      - rvm: ruby-2.0.0

bundle-install:
  module.run:
    - name: rvm.do
    - ruby: 2.0.0@{{ proj_name }}
    - command: RAILS_ENV=production bundle install
    - cwd: {{ root }}
    - runas: {{ user }}
    - require: 
      - rvm: {{ proj_name }}


