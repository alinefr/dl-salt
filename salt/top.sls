base:
  '*':
    - base

  'dldeploy.dlapp.co':
    - servers.dldeploy
    - postfix
    - munin.master.config
    - munin.node.config

  'dlapp.co':
    - postfix
    - servers.dlapp

  'ddll.co':
    - servers.ddll

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

