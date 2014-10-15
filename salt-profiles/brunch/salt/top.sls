base:
  '* and not gateway.doubleleft.com':
    - match: compound
    - sites.template
  '*':
    - base
    - rvm
    - brunch

