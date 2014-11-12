{% set plugins_dir = '/etc/munin/plugins' %}
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
] %}

{% for plugin in plugins_dir %}
{{ plugins_dir }}/{{ plugin }}:
  file:
    - absent
{% endfor %}
