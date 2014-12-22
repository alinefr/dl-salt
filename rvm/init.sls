{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set tsocks_bool = salt['pillar.get']('tsocks','') %}
{% if tsocks_bool == True %}
  {% set tsocks = 'tsocks'  %}
{% else %}
  {% set tsocks = '' %}
{% endif %}

rvm-deps:
  pkg.installed:
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core
      - subversion

mri-deps:
  pkg.installed:
    - names:
      - build-essential
      - openssl
      - libreadline6
      - libreadline6-dev
      - curl
      - git-core
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - subversion
      - ruby
      - libmysqlclient-dev

rvmrc:
  file.managed:
    - name: {{ user_home }}/.rvmrc
    - source: salt://rvm/rvmrc
    - user: {{ user }}    

rvm-gpg_key:
  cmd.run:
    - name: {{ tsocks }} gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    - user: {{ user }}
    - unless: gpg --list-keys D39DC0E2
    - require:
      - pkg: rvm-deps
  
ruby-2.0.0:
  rvm.installed:
    - default: True
    - user: {{ user }}
    - require:
      - pkg: mri-deps

{{ proj_name }}:
  rvm.gemset_present:
    - ruby: ruby-2.0.0
    - user: {{ user }}
    - require:
      - rvm: ruby-2.0.0

bundle-install:
  cmd.run:
    - name: {{ user_home }}/.rvm/bin/rvm 2.0.0@{{ proj_name }} do bundle install
    - cwd: {{ www_root }}
    - user: {{ user }}
    - require: 
      - rvm: {{ proj_name }}

