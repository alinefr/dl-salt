{% set user = salt['pillar.get']('project_username','deploy') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set root = salt['pillar.get']('project_path','/vagrant') %}
{% set mysql_user = proj_name|replace('-','')|truncate(15) %}
{% set mysql_db = mysql_user %}

{% if grains['host'] in ['odesmistificador'] %}
  {% set grants_ip = salt['network.interfaces']()['eth0']['inet'][0]['address'] %}
{% else %}
  {% set grants_ip = salt['pillar.get']('master:mysql.host','localhost') %}
{% endif %}

{% if not grains['host'] in ['ddll','staging','odesmistificador'] %}
mysql:
  cmd.run:
    - name: echo '{{ salt["grains.get_or_set_hash"]("mysql:root") }}' > /dev/null 2>&1

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
{% endif %}

mysql-client:
  pkg.installed

python-mysqldb:
  pkg.installed

dbconfig:
  cmd.run:
    - name: echo "{{ salt['grains.get_or_set_hash']('' ~ mysql_db ~ ':' ~ mysql_user ~ '') }}" > /dev/null 2>&1

  mysql_user.present:
    - name: {{ mysql_user }}
    - password: "{{ salt['grains.get']('' ~ mysql_db ~ ':' ~ mysql_user ~ '') }}"
    - host: {{ grants_ip }}
    - require:
      - cmd: dbconfig
      - pkg: python-mysqldb

  mysql_database.present:
    - name: {{ mysql_db }}
    - require:
      - mysql_user: dbconfig

  mysql_grants.present:
    - grant: all privileges
    - database: {{ mysql_db }}.*
    - user: {{ mysql_user }}
    - host: {{ grants_ip }}
    - require:
      - mysql_database: dbconfig 


