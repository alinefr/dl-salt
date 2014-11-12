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

munin_dynamic_template:
  git.latest:
    - name: https://github.com/DaveMDS/munin_dynamic_template.git
    - rev: master
    - target: /etc/munin/munin_dynamic_template

  file.symlink:
    - name: /etc/munin/templates
    - target: /opt/munin-jquery-template/templates
    - require:
      - file: /etc/munin/templates.bkp
      - git: munin_dynamic_template



