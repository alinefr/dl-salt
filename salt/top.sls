base:
  '*':
    - base
    {% if salt['pillar.get']('dbdriver') == 'mysql' %}
    - mysql
    {% endif %}
    {% if not ( salt['pillar.get']('environment') == 'ddll' or salt['pillar.get']('environment') == 'staging' ) %}
    - nginx
    - sites.template
    - php_fpm
    {% endif %}
    {% if salt['pillar.get']('setup') == 'dlapi' %}
    - dlapi
    {% elif salt['pillar.get']('setup') == 'rails' %}
    - rvm
    {% endif %}

