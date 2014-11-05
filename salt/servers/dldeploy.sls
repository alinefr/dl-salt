python-pygit2:
  pkgrepo.absent:
    - ppa: dennis/python

  pkg.removed:
    - refresh: True

salt '*' cmd.run cmd='/opt/lpvs/lpvs scan' env='{HOME: /root}':
  cron.present:
    - user: root
    - minute: 05
    - hour: 02
