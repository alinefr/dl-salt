base:
  'dev':
    - match: nodegroup
    - base
    {% if salt['pillar.get']('dbdriver') == 'mysql' %}
    - mysql
    {% endif %}
    - nginx
    - sites.template
    {% if salt['pillar.get]('build','disabled') == 'brunch' %}
    - rvm
    {% endif %}
    {% if salt['pillar.get']('setup') == 'dlapi' %}
    - dlapi
    {% elif salt['pillar.get']('setup') == 'wordpress' %}
    - wordpress
    {% endif %}

