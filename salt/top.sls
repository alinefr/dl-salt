base:
  '*':
    - base
    {% if salt['pillar.get']('dbdriver') == 'mysql' %}
    - mysql
    {% endif %}
    {% if not ( salt['pillar.get']('setup') == 'ddll' or salt['pillar.get']('setup') == 'staging' ) %}
    - nginx
    - php_fpm
    - sites.template
    {% endif %}
    {% if salt['pillar.get']('setup') == 'dlapi' %}
    - dlapi
    {% elif salt['pillar.get']('setup') == 'rails' %}
    - rvm
    {% endif %}

