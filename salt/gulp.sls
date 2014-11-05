{% import "base.sls" as base with context %}

npm-deps:
  pkg.installed:
    - pkgs:
      - nodejs
      - nodejs-legacy
      - npm

npm-install:
  npm.bootstrap: 
    - name: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - pkg: npm-deps

bower:
  npm.installed:
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/node_modules

bower-install:
  cmd.run:
    - name: {{ base.pre_arg }} {{ base.www_root }}/node_modules/.bin/bower install --config.interactive=false
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install

gulp-exec:
  cmd.run:
    - name: {{ base.pre_arg }} {{ base.www_root }}/node_modules/.bin/gulp
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install

