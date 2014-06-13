# This state file is installs and configures the dlapi environment 

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

{{ pillar['root'] }}/{{ pillar['project_name'] }}/api/app/storage:
  file.directory:
    - user: deploy
    - group: www-data
    - mode: 775
    - makedirs: True

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

  

