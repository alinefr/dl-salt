base:
  '* and not gateway.doubleleft.com':
    - match: compound
    - sites.template
  'profile:brunch':
    - match: pillar
    - base
    - rvm
    - brunch

