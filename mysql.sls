{% import "base.sls" as base with context %}

{% set mysql_user = base.proj_name|replace('-','')|truncate(15) %}
{% set mysql_db = mysql_user %}
{% set mysql_host = 'localhost' %}

mysql:
  cmd.run:
    - name: salt-call grains.get_or_set_hash 'mysql:root' 75

  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': "{{ salt['grains.get']('mysql:root') }}"}
        'mysql-server/root_password_again': {'type': 'password', 'value': "{{ salt['grains.get']('mysql:root') }}"}
        'mysql-server/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require:
      - cmd: mysql

    - require_in:
      - pkg: mysql

  pkg.installed:
    - name: mysql-server
    - require: 
      - debconf: mysql


  service.running:
    - enable: True
    - require:
      - pkg: mysql

mysql-client:
  pkg.installed

python-mysqldb:
  pkg.installed

dbconfig:
  cmd.run:
    - name: salt-call grains.get_or_set_hash '{{ mysql_db }}:{{ mysql_user }}' 

  mysql_user.present:
    - name: {{ mysql_user }}
    - password: "{{ salt['grains.get']('' ~ mysql_db ~ ':' ~ mysql_user ~ '') }}"
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ salt['grains.get']('mysql:root') }}'
    - connection_charset: utf8
    - require:
      - cmd: dbconfig
      - pkg: python-mysqldb

  mysql_database.present:
    - name: {{ mysql_db }}
    - connection_user: root
    - connection_pass: '{{ salt['grains.get']('mysql:root') }}'
    - connection_charset: utf8
    - require:
      - mysql_user: dbconfig

  mysql_grants.present:
    - grant: all privileges
    - database: {{ mysql_db }}.*
    - user: {{ mysql_user }}
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ salt['grains.get']('mysql:root') }}'
    - connection_charset: utf8
    - require:
      - mysql_database: dbconfig 


