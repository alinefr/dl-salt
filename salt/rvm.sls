{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}
{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}

rvm-deps:
  pkg.installed:
    - names:
      - build-essential
      - gnupg
      - libreadline-gplv2-dev
      - libsqlite3-dev 
      - libxml2-dev 
      - zlib1g-dev

rvm-gpg_key:
  cmd.run:
    - name: gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    - user: {{ user }}
    - unless: gpg --list-keys D39DC0E2
    - require:
      - pkg: rvm-deps
  
ruby-2.0.0:
  rvm.installed:
    - default: True
    - user: {{ user }}
    - require:
      - cmd: rvm-gpg_key

{{ proj_name }}:
  rvm.gemset_present:
    - ruby: ruby-2.0.0
    - user: {{ user }}
    - require:
      - rvm: ruby-2.0.0

bundle-install:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do bundle install
    - cwd: {{ root }}
    - user: {{ user }}
    - require: 
      - rvm: {{ proj_name }}


