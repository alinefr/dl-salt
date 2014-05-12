{{ pillar['user'] }}:
  group:
    - present
  user:
    - present
    - shell: /bin/bash
    - groups: 
      - {{ pillar['user'] }}
    - require:
      - group: {{ pillar['user'] }}

ubuntu:
  group:
    - present
  user:
    - present
    - shell: /bin/bash
    - groups:
      - ubuntu
    - require:
      - group: ubuntu

{% if salt['pillar.get']('team') == 'devops' %}
/home/ubuntu/.ssh/authorized_keys:
  file.managed:
    - source: salt://base/devopskey
    - user: ubuntu
    - group: ubuntu
    - mode: 0600
    - makedirs: True
{% else %}
/home/ubuntu/.ssh/authorized_keys:
  file.managed:
    - source: salt://base/sshkey
    - user: ubuntu
    - group: ubuntu
    - mode: 0600
    - makedirs: True
{% endif %}

/home/{{ pillar['user'] }}/.bashrc:
  file.managed:
    - source:
      - salt://base/dot_bashrc
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
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

{% if salt['pillar.get']('environment') == 'dlapi' %}
npm:
  pkg:
    - installed

/usr/bin/node:
  file.symlink:
    - target: /usr/bin/nodejs
    - require:
      - pkg: npm
 
ssh-private-key:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.ssh/id_rsa
    - source: salt://base/sshkey
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 600
{% endif %}

