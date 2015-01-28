{% import "base.sls" as base with context %}
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
    - name: {{ base.user_home }}/.rvmrc
    - source: salt://rvm/rvmrc
    - user: {{ base.user }}    

rvm-gpg_key:
  cmd.run:
    - name: gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    - user: {{ base.user }}
    - unless: gpg --list-keys D39DC0E2
    - require:
      - pkg: rvm-deps
  
ruby-2.0.0:
  rvm.installed:
    - default: True
    - user: {{ base.user }}
    - require:
      - pkg: mri-deps

{{ base.proj_name }}:
  rvm.gemset_present:
    - ruby: ruby-2.0.0
    - user: {{ base.user }}
    - require:
      - rvm: ruby-2.0.0

bundle-install:
  cmd.run:
    - name: {{ base.user_home }}/.rvm/bin/rvm 2.0.0@{{ base.proj_name }} do bundle install
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require: 
      - rvm: {{ base.proj_name }}

