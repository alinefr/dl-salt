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

{% if salt['cmd.run']('test -f ' ~ salt['pillar.get']('project_path','/vagrant') ~ '/bower.json && echo "yes" || echo "no"') == 'yes' %}
bower:
  npm.installed:
    - user: {{ base.user }}
    - dir: {{ base.www_root }}/node_modules
    - require:
      - npm: npm-install

  cmd.run:
    - name: {{ base.pre_args }} {{ base.www_root }}/node_modules/.bin/bower install --config.interactive=false
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install
{% endif %}

gulp-exec:
  cmd.run:
    - name: {{ base.pre_args }} {{ base.www_root }}/node_modules/.bin/gulp
    - cwd: {{ base.www_root }}
    - user: {{ base.user }}
    - require:
      - npm: npm-install

