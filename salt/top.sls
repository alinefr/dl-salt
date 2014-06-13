base:
  '*':
    - base
    {% if salt['pillar.get']('dbdriver') == 'mysql' %}
    - mysql
    {% endif %}
    - nginx
    - php_fpm
    - sites.template
    {% if salt['pillar.get']('setup') == 'dlapi' %}
    - dlapi
    {% elif salt['pillar.get']('setup') == 'rails' %}
    - rvm
    {% endif %}

