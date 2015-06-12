{% import "base.sls" as base with context %}

hook-deps:
  pkg.installed:
    - pkgs:
      - git
      - npm
      - nodejs
      - nodejs-legacy
      - php5-cli

get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f {{ base.www_root }}/composer.phar
    - cwd: {{ base.www_root }}
    - require:
      - pkg: hook-deps

composer-install:
  cmd.run:
    - name: php composer.phar self-update
    - user: {{ base.user }}
    - cwd: {{ base.www_root }}
    - require:
      - cmd: get-composer
      - pkg: hook-deps
    - onlyif: php composer.phar status | grep 'build of composer is over 30 days old' > /dev/null 2>&1

install-hook:
  cmd.run:
    - name: php composer.phar install --no-interaction --no-dev --prefer-dist
    - cwd: /srv/www/hook
    - user: {{ base.user }}
    - require:
      - cmd: composer-install

{% if base.user != 'vagrant' %}
{{ base.www_root }}/public/storage:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 775
    - makedirs: True

{{ base.www_root }}/shared:
  file.directory:
    - user: {{ base.user }}
    - group: www-data
    - mode: 775
    - makedirs: True
{% endif %}

{{ base.www_root }}/config/database.php:
  file.managed:
    - source: salt://hook/database.php
    - user: {{ base.user }}
    - context:
      mysql_host: {{ salt['pillar.get']('master:mysql.host') }}
      mysql_user: {{ salt['pillar.get']('master:mysql.user') }}
      mysql_pass: {{ salt['pillar.get']('master:mysql.pass') }}
      mysql_db: {{ salt['pillar.get']('master:mysql.db') }}
    - template: jinja
    - require:
      - cmd: install-hook
