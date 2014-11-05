base:
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

  'dldeploy.dlapp.co':
    - servers.dldeploy

  'dlapp.co':
    - postfix

