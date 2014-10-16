base:
  '* and not gateway.doubleleft.com':
    - match: compound
    - sites.template
  '*':
    - grunt
    - s3upload

