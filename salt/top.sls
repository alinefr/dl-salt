base:
  '*':
    - base
    - munin.node.config

  'dldeploy.dlapp.co':
    - servers.dldeploy
    - postfix
    - munin.master.config

  'dlapp.co':
    - postfix
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

