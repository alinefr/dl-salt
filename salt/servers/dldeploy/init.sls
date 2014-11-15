cron_lpvs:
  cron.present:
    - name: "salt '*' cmd.run cmd='/opt/lpvs/lpvs scan' env='{HOME: /root}'"
    - user: root
    - minute: 00
    - hour: 02

include:
  - servers.dldeploy.munin_template
  - servers.dldeploy.monit_template

# install munin_update plugin
/etc/munin/plugins/munin_update:
  file.symlink:
    - target: /usr/share/munin/plugins/munin_update

munin_dynamic_template:
  git.latest:
    - name: https://github.com/DaveMDS/munin_dynamic_template.git
    - rev: master
    - target: /etc/munin/munin_dynamic_template

  file.managed:
    - name: /etc/munin/munin_dynamic_template/munin2/template.conf
    - source: salt://servers/dldeploy/munin_dynamic_template.conf

# workaround salt vars inside py renderer
templates_patch:
  file.patch: 
    - name: /usr/lib/python2.7/dist-packages/salt/utils/templates.py
    - source: salt://templates_env.patch
    - hash: md5=d1c01913dc1a056e751cbedaba89805d

open-m-monit:
  git.latest:
    - name: https://github.com/antoniopuero/open-m-monit.git
    - rev: master
    - target: /srv/www/open-m-monit

  file.managed:
    - name: /srv/www/open-m-monit/config.json
    - source: salt://servers/dldeploy/config.py
    - template: py
    - require:
      - git: open-m-monit
      - file: templates_patch

open-m-monit_bind:
  file.serialize:
    - name: /srv/www/open-m-monit/port.json
    - source: salt://servers/dldeploy/port.py
    - template: py
    - require:
      - git: open-m-monit
      - file: templates_patch


