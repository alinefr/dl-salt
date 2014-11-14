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

munin_dynamic_template:
  git.latest:
    - name: https://github.com/DaveMDS/munin_dynamic_template.git
    - rev: master
    - target: /etc/munin/munin_dynamic_template

  file.managed:
    - name: /etc/munin/munin_dynamic_template/munin2/template.conf
    - source: salt://servers/dldeploy/munin_dynamic_template.conf

open-m-monit:
  git.latest:
    - name: https://github.com/antoniopuero/open-m-monit.git
    - rev: master
    - target: /srv/www/open-m-monit

  file.serialize:
    - name: /srv/www/open-m-monit/config.json
    - dataset: 
      clusterName:
      {%- for host, hostinfo in salt['mine.get']('*', 'network.interfaces').items() %}
        hostname: {{ host }}
        username: {{ salt['pillar.get']('monit:http_access:user') }}
        password: {{ salt['pillar.get']('monit:http_access:password') }}
      {%- endfor %}
    - formatter: json
    - require:
      - git: open-m-monit


