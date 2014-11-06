mailutils:
  pkg.installed

/home/deploy/bin/monitor.sh:
  file.managed:
    - source: salt://servers/dlapp/monitor.sh
    - user: deploy
    - makedirs: True
    - mode: 755

  cron.present:
    - user: deploy
   
monitor_email:
  cron.present:
    - name: /home/deploy/bin/monitor.sh 2>&1 | mail tools@doubleleft.com
    - user: deploy
    - minute: 0
    - require:
      - pkg: mailutils
    
