base:
  'os:Ubuntu':
    - match: grain
    - base

  'G@os:Ubuntu and not gateway.doubleleft.com':
    - match: compound
    - nginx.template

  'profile:brunch':
    - match: pillar
    - brunch

  'profile:gulp':
    - match: pillar
    - gulp

  'profile:grunt':
    - match: pillar
    - grunt

  'profile:rails':
    - match: pillar
    - rails

  'profile:hook':
    - match: pillar
    - hook

  'profile:php':
    - match: pillar
    - php_fpm
