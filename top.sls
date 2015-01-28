base:
  'os:Ubuntu':
    - match: grain
    - base

  'profile:brunch':
    - match: pillar
    - nginx.template
    - brunch

  'profile:gulp':
    - match: pillar
    - nginx.template
    - gulp

  'profile:grunt':
    - match: pillar
    - nginx.template
    - gulp

  'profile:rails':
    - match: pillar
    - nginx.template
    - rails

  'profile:hook':
    - match: pillar
    - nginx.template
    - hook

