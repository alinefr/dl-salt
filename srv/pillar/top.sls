base:
  "*":
    - sshd
    - sysctl
    - pg 
    - vagrant_user
    {% if pillar['dbdriver'] == 'mysql' %}
    - mysql
    {% endif %}

