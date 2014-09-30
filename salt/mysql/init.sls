{% set user = salt['pillar.get']('project_username','deploy') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set mysql_user = salt['cmd.run']('echo ${' ~ proj_name ~ '//-/}') %}
{% set mysql_db = mysql_user %}

mysql-server:
  pkg.installed: []
  service.running:
    - name: mysql
    - enable: True
    - require:
      - pkg: mysql-server

{% if ( grains['host'] != 'ddll' or grains['host'] != 'staging' ) %}
set-root-password:
  mysql_user.present:
    - name: root
    - password: {{ salt['grains.get_or_set_hash']('mysql:root') }}
    - require:
      - pkg: mysql-server
      - service: mysql
{% endif %}

mysql:
  service.running:
    - name: mysql
    - require:
      - pkg: mysql-server

python-mysqldb:
  pkg.installed

dbconfig:
  mysql_user.present:
    - name: {{ mysql_user }}
    - password: {{ salt['grains.get_or_set_hash']('mysql:' ~ mysql_user ~ '') }}
    - require:
      - service: mysql
      - pkg: python-mysqldb

  mysql_database.present:
    - name: {{ mysql_db }}
    - require:
      - mysql_user: dbconfig

  mysql_grants.present:
    - grant: all privileges
    - database: {{ mysql_db }}.*
    - user: {{ mysql_user }}
    - require:
      - mysql_database: dbconfig 
