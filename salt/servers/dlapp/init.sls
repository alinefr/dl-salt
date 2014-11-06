/home/deploy/bin/monitor.sh:
  file.managed:
    - source: salt://servers/dlapp/monitor.sh
    - user: deploy
    - makedirs: True
    - mode: 755

  cron.present:
    - user: deploy
    
