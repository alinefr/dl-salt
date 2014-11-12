{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set user_home = salt['user.info'](user).home %}

{% if salt['cmd.run']('test -f ' ~ salt['pillar.get']('project_path','/vagrant') ~ '/Gemfile && echo "yes" || echo "no"') == 'yes' %}
include:
  - rvm
  {% set pre_args = '' ~ user_home ~ '/.rvm/bin/rvm 2.0.0@' ~ proj_name ~ ' do' %}
{% else %}
  {% set pre_args = '' %}
{% endif %}

# install git
git:
  pkg.installed

{% if salt['pillar.get']('project_username') %}
git.config_set:
  module.run:
    - setting_name: url.https://.insteadOf
    - setting_value: git://
    - user: {{ user }}
    - is_global: True
    - cwd: {{ www_root }}
    - require:
      - pkg: git
{% endif %}

# lpvs scanner + perl dep
libxml-libxslt-perl:
  pkg.installed

https://github.com/lwindolf/lpvs.git:
  git.latest:
    - rev: master
    - target: /opt/lpvs

# at needs to be running for salt-minion restart 1 minute later
at:
  pkg:
    - installed
  service.running:
    - name: atd
    - enable: True

# configure "mine" to get all servers for munin
/etc/salt/minion.d/mine.conf:
  file.managed:
    - source: salt://base/mine.conf
    - makedirs: True
    - user: root
    - watch_in:
      - cmd: /etc/salt/minion.d/mine.conf

  cmd.wait:
    - name: echo service salt-minion restart | at now + 1 minute
    - watch: 
      - file: /etc/salt/minion.d/mine.conf
    - require: 
      - pkg: at

# setup for motd
ssh:
  pkg:
    - installed

  service:
    - running

custom_motd:
  file.managed:
    - name: /etc/motd.tail
    - source: salt://base/motd.tail

set_banner:
{% if 'Banner' in salt['cmd.run']('grep Banner /etc/ssh/sshd_config') %}
  file.replace:
    - pattern: "[!#]Banner.*$"
    - repl: "Banner /etc/motd.tail"
{% else %}
  file.append:
    - text:
      - Banner /etc/motd.tail
{% endif %}
    - name: /etc/ssh/sshd_config
    - watch_in:
      - service: ssh
    - require:
      - file: custom_motd
