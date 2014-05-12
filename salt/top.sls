base:
  '*':
    - base
    - mysql
    - nginx
    - php_fpm
    - sites.template
    {% if salt['pillar.get']('environment') == 'dlapi' %}
    - dlapi
    {% endif %}

