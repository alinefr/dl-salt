cron_lpvs:
  cron.present:
    - name: "salt '*' cmd.run cmd='/opt/lpvs/lpvs scan' env='{HOME: /root}'"
    - user: root
    - minute: 00
    - hour: 02

include:
  - servers.dldeploy.munin_template

# install munin_update plugin
/etc/munin/plugins/munin_update:
  file.symlink:
    - target: /usr/share/munin/plugins/munin_update

# install new template
/etc/munin/templates.bkp:
  file.rename:
    - source: /etc/munin/templates

munin-jquery-template:
  git.latest:
    - name: https://github.com/mallocator/Munin-JQuery-Template.git:
    - rev: master
    - target: /opt/munin-jquery-template

  file.symlink:
    - name: /etc/munin/templates
    - target: /opt/munin-jquery-template/template
    - require:
      - file: /etc/munin/templates.bkp
      - git: munin-jquery-template


