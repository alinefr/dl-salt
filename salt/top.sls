base:
  'dev':
    - match: nodegroup
    - base
    {% if salt['pillar.get']('dbdriver') == 'mysql' %}
    - mysql
    {% endif %}
    - nginx
    {% if salt['pillar.get']('setup') == 'dlapi' %}
    - dlapi
    {% elif salt['pillar.get']('setup') == 'rails' %}
    - rvm
    {% elif salt['pillar.get']('setup') == 'wordpress' %}
    - wordpress
    {% endif %}

