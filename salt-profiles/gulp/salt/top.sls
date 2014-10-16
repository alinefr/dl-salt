base:
  '* and not gateway.doubleleft.com':
    - match: compound
    - nginx.nginx_project
  '*':
    - base
    - rvm
    - gulp

