{{ pillar['group'] }}:
  group.present:
    - system: False

{{ pillar['user'] }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ pillar['user'] }}
    - groups: 
      - {{ pillar['group'] }}

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


