munin-plugins-extra:
  pkg.installed

{% set plugins_dir = '/etc/munin/plugins' %}
{% set plugins_src = '/usr/share/munin/plugins' %}
{% set absent_plugins = [ 
  'if_dummy0', 
  'if_err_dummy0', 
  'if_err_gre0',
  'if_err_gretap0',
  'if_err_ip6gre0',
  'if_err_ip6tnl0',
  'if_err_ip6_vti0',
  'if_err_ip_vti0',
  'if_err_teql0',
  'if_err_tunl0',
  'if_gre0',
  'if_gretap0',
  'if_ip6gre0',
  'if_ip6tnl0',
  'if_ip6_vti0',
  'if_ip_vti0',
  'if_teql0',
  'if_tunl0',
  'nfs4_client',
  'nfs_client',
  'nfsd',
  'nfsd4',
  'tomcat_jvm',
  'tomcat_access',
  'tomcat_avgtime',
  'tomcat_maxtime',
  'tomcat_threads',
  'tomcat_volume'
] %}

{% for rm_plugin in absent_plugins %}
{{ plugins_dir }}/{{ rm_plugin }}:
  file:
    - absent
{% endfor %}

{% set enabled_plugins = [
  'http_loadtime',
  'nginx_request',
  'nginx_status',
  'tcp'
] %}
{% for plugin in enabled_plugins %}
{{ plugins_dir }}/{{ plugin }}:
  file.symlink:
    - target: {{ plugins_src }}/{{ plugin }}
{% endfor %}

{% if salt['pkg.version']('mysql-server') %}
mysql_munin_deps:
  pkg.installed:
    - names:
      - libdbi-perl
      - libcache-cache-perl

{{ plugins_dir }}/mysql_file_tables
  file:
    - absent

{% set enabled_mysql = [
  'commands',
  'connections',
  'files_tables',
  'network_traffic',
  'qcache',
  'qcache_mem',
  'select_types',
  'slow',
  'sorts',
  'table_locks'
] %}
{% for mysql_plugin in enabled_mysql %}
{{ plugins_dir }}/mysql_{{ mysql_plugin }}:
  file.symlink:
    - target: {{ plugins_src }}/mysql_
    - require:
      - pkg: mysql_munin_deps
{% endfor %}

{{ plugins_dir }}/ps_mysql:
  file:
    - absent

{% endif %}

{% if salt['pkg.version']('openvpn') %}
{{ plugins_dir }}/openvpn:
  file.symlink:
    - target: {{ plugins_src }}/openvpn
{% endif %}

{% set enabled_ps = [
  'mysqld',
  'php-fpm',
  'nginx',
  'sshd'
] %}
{% for ps_plugin in enabled_ps %}
{{ plugins_dir }}/ps_{{ ps_plugin }}:
  file.symlink:
    - target: {{ plugins_src }}/ps_
{% endfor %}   

include:
  - .munin_plugins_nginx
