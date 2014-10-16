base:
  'dev':
    - match: nodegroup
    - base
    - mysql
    - nginx
    - sites.template
    - rvm
    {% endif %}
    {% if salt['pillar.get']('setup') == 'dlapi' %}
    - dlapi
    {% elif salt['pillar.get']('setup') == 'wordpress' %}
    - wordpress
    {% endif %}

