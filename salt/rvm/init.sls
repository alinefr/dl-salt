{% set user = salt['pillar.get']('project_username','deploy') %}
{% set root = salt['pillar.get']('project_path','/srv/www') %}

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

ruby-2.0.0:
  rvm:
    - installed
    - default: True
    - runas: {{ user }}
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps
      - user: {{ user }}

{{ salt['pillar.get']('project_name') }}:
  rvm:
    - gemset_present
    - ruby: ruby-2.0.0
    - runas: {{ user }}
    - require:
      - rvm: ruby-2.0.0

bundle-install:
  cmd.run:
    - name: bundle install
    - cwd: {{ root }}
    - runas: {{ user }}
    - ruby: 2.0.0@{{ salt['pillar.get']('project_name') }}
    - require: 
      - rvm: {{ salt['pillar.get']('project_name') }}

