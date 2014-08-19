mysql-server:
  pkg.installed: []
  service.running:
    - name: mysql
    - enable: True
    - require:
      - pkg: mysql-server

{% if ( grains['host'] != 'ddll' or grains['host'] != 'staging' ) %}
set-mysql-root-password:
  cmd.run:
    - name: PASSWORD=$'{{salt['pw_safe.get']('mysql.root')}}'; echo "update user set password=PASSWORD('$PASSWORD') where User='root'; flush privileges;" | mysql -uroot mysql
    - onlyif: '[ ! -f /root/.my.cnf ]'
    - require:
      - pkg: mysql-server
      - service: mysql

change-mysql-root-password:
   cmd.run:
     - name: service mysql stop && mysqld_safe --skip-grant-tables & export PASSWORD=`cat /root/.my.cnf | grep password= | awk -F\' '{print $2}'`; echo "update user set password=PASSWORD('$PASSWORD') where User='root';flush privileges;" | mysql -u root mysql && killall mysqld && service mysql start
     - onlyif: mysqlshow -u root 
     - require:
       - cmd: set-mysql-root-password

/root/.my.cnf:
  file.managed:
    - user: root
    - group: root
    - mode: '0600'
    - contents: "# this file is managed by salt; changes will be overriden!\n[client]\npassword='{{salt['pw_safe.get']('mysql.root')}}'\n"
    - require:
      - cmd: set-mysql-root-password
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
    - name: {{ pillar['mysql_user'] }}
    - password: {{ pillar['mysql_pass'] }}
    - require:
      - service: mysql
      - pkg: python-mysqldb

  mysql_database.present:
    - name: {{ pillar['mysql_db'] }}
    - require:
      - mysql_user: dbconfig

  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['mysql_db'] }}.*
    - user: {{ pillar['mysql_user'] }}
    - require:
      - mysql_database: dbconfig 

{{ salt['pillar.get']('project_path')}}/.dbdata:
  file.managed:
    - user: ubuntu
    - group: ubuntu
    - mode: 0600
    - contents: "# this file is managed by salt; changes will be overriden!\nuser: '{{salt['pillar.get']('dbuser')}}'\npassword: '{{salt['pillar.get']('dbpass')}}'\ndatabase: '{{salt['pillar.get']('dbname')}}'\n"

