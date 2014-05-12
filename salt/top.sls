base:
  '*':
    - base
    - mysql
    {% if salt['pillar.get']('dbdriver') == 'mysql' %}
    - nginx
    {% endif %}
    - php_fpm
    - sites.template
    {% if salt['pillar.get']('environment') == 'dlapi' %}
    - dlapi
    {% endif %}

