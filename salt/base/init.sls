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

git:
  pkg.installed

