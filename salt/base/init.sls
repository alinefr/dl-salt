{% set user = salt['pillar.get']('project_username','deploy') %}

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

{% set sudouser = salt['pillar.get']('sudouser','ubuntu') %}
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


