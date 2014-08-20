{% if salt['pillar.get']('project_username') is defined %}
  {% set user = salt['pillar.get']('project_username') %}
{% else %}
  {% set user = pillar['user'] %}
{% endif %}

{{ user }}:
  group:
    - present
  user:
    - present
    - shell: /bin/bash
    - groups: 
      - {{ user }}
    - require:
      - group: {{ user }}

{% if salt['pillar.get']('sudouser') is defined %}
  {% set sudouser = salt['pillar.get']('sudouser') %}
{% else %}
  {% set sudouser = 'ubuntu' %}
{% endif %}

{{ sudouser }}:
  group:
    - present
  user:
    - present
    - shell: /bin/bash
    - groups:
      - {{ sudouser }}
    - require:
      - group: {{ sudouser }}

{% if salt['pillar.get']('team') == 'devops' %}
/home/{{ sudouser }}/.ssh/authorized_keys:
  file.managed:
    - source: salt://base/authorized_keys_devops
    - user: {{ sudouser }}
    - group: {{ sudouser }} 
    - mode: 0600
    - makedirs: True
{% elif sudouser == 'vagrant' %}
/home/{{ sudouser }}/.ssh/authorized_keys:
  file.managed:
    - user: {{ sudouser }}
    - group: {{ sudouser }}
    - mode: 0600
    - makedirs: True
    - contents: "# CLOUD_IMG: This file was created/modified by the Cloud Image build process\nssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key\n"
{% else %}
/home/{{ sudouser }}/.ssh/authorized_keys:
  file.managed:
    - source: salt://base/authorized_keys
    - user: {{ sudouser }}
    - group: {{ sudouser }}
    - mode: 0600
    - makedirs: True
{% endif %}

/home/{{ user }}/.bashrc:
  file.managed:
    - source:
      - salt://base/dot_bashrc
    - user: {{ user }}
    - group: {{ user }}
    - mode: 644
    - backup: minion

/usr/lib/python2.7/dist-packages/salt/modules/mysql.py:
  file.managed:
    - source:
      - salt://base/mysql.py
    - user: root
    - group: root
    - mode: 644
    - backup: minion

git:
  pkg:
    - installed

{% if salt['pillar.get']('setup') == 'dlapi' %}
npm:
  pkg:
    - installed

nodejs-legacy:
  pkg:
    - installed

ssh-private-key:
  file.managed:
    - name: /home/{{ user }}/.ssh/id_rsa
    - source: salt://base/sshkey
    - user: {{ user }}
    - group: {{ user }}
    - mode: 600
    - makedirs: True
{% elif salt['pillar.get']('setup') == 'flask' %}
python-virtualenv:
  pkg:
    - installed
{% endif %}


