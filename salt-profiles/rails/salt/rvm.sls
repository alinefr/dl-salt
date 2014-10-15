{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}

rvm-deps:
  pkg:
    - installed
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
      - sudo

mri-deps:
  pkg:
    - installed
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

ruby-2.0.0:
  rvm:
    - installed
    - default: True
    - runas: {{ user }}
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps

{{ proj_name }}:
  rvm:
    - gemset_present
    - ruby: ruby-2.0.0
    - runas: {{ user }}
    - require:
      - rvm: ruby-2.0.0

bundle-install:
  cmd.run:
    - name: "source ~{{ user }}/.rvm/scripts/rvm; rvm 2.0.0@{{ proj_name }} exec bundle install --system"
    - env:
      - RAILS_ENV: production
    - cwd: {{ root }}
    - user: {{ user }}
    - require: 
      - rvm: {{ proj_name }}


