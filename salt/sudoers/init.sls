{% set sudouser = salt['pillar.get']('sudouser','ubuntu') -%}
{% set user = salt['pillar.get']('user','deploy') -%}

sudo:
  pkg.installed

/etc/sudoers.d/{{ sudouser }}:
  file.managed:
    - user: root
    - mode: 440
    - template: jinja
    - source: salt://sudoers/sudouser
    - context:
        included: False
    - require:
      - pkg: sudo

/etc/sudoers.d/{{ user }}:
  file.managed:
    - user: root
    - mode: 440
    - template: jinja
    - source: salt://sudoers/user
    - context:
        included: False
    - require:
      - pkg: sudo


