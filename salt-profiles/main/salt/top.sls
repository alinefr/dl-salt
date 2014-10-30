base:
  '* and not gateway.doubleleft.com':
    - match: compound
    - sites.template
 
  '*':
    - base

  'profile:brunch':
    - match: pillar
    - brunch

  'profile:gulp':
    - match: pillar
    - gulp
