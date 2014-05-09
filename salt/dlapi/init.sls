# This state file is installs and configures the base wordpress environment 

# this is the symlink to the virtual box sync folder WP will live in, the target needs to match 
# /var/www/html/wordpress:
#  file.symlink:
#   - target: /www_src

# This block creates the wordpress database, user and sets user access. 
# wordpress_db:
#  mysql_database.present:
#   - name: wordpress
#  mysql_user.present:
#   - name: wordpress
#   - password: password
#  mysql_grants.present:
#   - database: wordpress.*
#   - grant: ALL PRIVILEGES
#   - user: wordpress
#   - host: '%'

get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - require:
      - pkg: php_cli

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root
    - watch: 
      - cmd: get-composer

dl-api:
  git.latest:
    - name: git@github.com:doubleleft/dl-api.git
    - rev: master
    - target: {{ pillar['root'] }}/{{ pillar['project_name'] }}
    - user: {{ pillar['user'] }}
    - identity: /home/{{ pillar['user'] }}/.ssh/id_rsa
    - force: True
    - require:
      - pkg: git
      - file: ssh-private-key
  cmd.wait:
    - name: make
    - user: {{ pillar['user'] }}
    - cwd: {{ pillar['root'] }}/{{ pillar['project_name'] }}
    - require:
      - pkg: npm
    - watch:
      - git: dl-api


{{ pillar['root'] }}/{{ pillar['project_name'] }}/api/app/config/database.php:
  file.managed:
    - source: 
      - salt://dlapi/database.php
      - user: {{ pillar['user'] }}
      - group: {{ pillar['group'] }}
      - mode: 644
      - backup: minion
    - template: jinja
    - require:
      - git: dl-api

dl-api-genkey:
  cmd.run:
    - name: /home/{{ pillar['user'] }}/bin/dl-api -e http://{{ pillar['server_name'] }} app:new {{ pillar['server_name'] }}
    - user: {{ pillar['user'] }}
    - unless: dl-api apps | grep '\b{{ pillar['server_name'] }}$'
    - onlyif: test -f /home/{{ pillar['user'] }}/bin/dl-api
    - cwd: {{ pillar['root'] }}/{{ pillar['project_name'] }}

  

