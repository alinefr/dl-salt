base:
  'os:Ubuntu':
    - match: grain
    - base
    - monit
    - base.monit_modules
    - postfix
    - munin.node.plugins
    - base.munin_plugins

  'dldeploy.dlapp.co':
    - servers.dldeploy
    - munin.master.config

  'dlapp.co':
    - servers.dlapp

  'profile:brunch':
    - match: pillar
    - base
    - sites.template
    - brunch

  'profile:gulp':
    - match: pillar
    - base
    - sites.template
    - gulp

  'profile:rails':
    - match: pillar
    - base
    - sites.template
    - rails

  'profile:hook':
    - match: pillar
    - base
    - sites.template
    - hook
