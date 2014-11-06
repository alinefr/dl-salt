{% import "base/init.sls" as base with context %}

{{ base.user_home }}/bin/monitor.sh
  file.managed:
    - source: salt://servers/dlapp/monitor.sh
    - user: deploy
    - makedirs: True
    - mode: 755

  cron.present:
    - user: deploy
    
