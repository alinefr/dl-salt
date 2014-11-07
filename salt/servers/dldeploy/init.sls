python-pygit2:
  pkgrepo.absent:
    - ppa: dennis/python

  pkg.removed:
    - refresh: True

cron_lpvs:
  cron.present:
    - name: "salt '*' cmd.run cmd='/opt/lpvs/lpvs scan' env='{HOME: /root}'"
    - user: root
    - minute: 00
    - hour: 02

include:
  - servers.dldeploy.munin_template
