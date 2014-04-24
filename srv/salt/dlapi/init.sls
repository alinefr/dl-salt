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
    - target: {{ pillar['root'] }}
    - identity: /home/{{ pillar['user'] }}/.ssh/id_rsa
    - force: True
    - require:
      - pkg: git
      - pkg: npm
      - file: ssh-private-key
  cmd.wait:
    - name: make
    - cwd: {{ pillar['root'] }}
    - watch:
      - git: dl-api

{{ pillar['root'] }}/app/config/database.php
  file.managed:
    - source: 
      - salt://dlapi/database.php
      - user: {{ pillar['user'] }}
      - group: {{ pillar['group'] }}
      - mode: 644
      - backup: minion


  

