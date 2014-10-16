{% set user = salt['pillar.get']('project_username','vagrant') %}
{% set www_root = salt['pillar.get']('project_path','/vagrant') %}
{% set proj_name = salt['pillar.get']('proj_name','myproject') %}
{% set servers = ['ddll','staging','gateway'] %}
{% if ('ddll' in grains['host'] or 'staging' in grains['host']) %}
  {% set build_target = grains['host'] %}
{% else %}
  {% set build_target = salt['pillar.get']('build_target','') %}
{% endif %}

s3cmd-upload:
  cmd.run:
    - name: s3cmd put -P --recursive ./assets s3://{{ proj_name }}-{{ build_target }}
    - cwd: {{ www_root }}/deploy
    - user: {{ user }}
    - onlyif: python -c "import sys; sys.exit(0) if '{{ grains['host'] }}' in {{ servers }} else sys.exit(1)"

s3cmd-upload-mobile:
  cmd.run:
    - name: s3cmd put -P --recursive ./assets s3://{{ proj_name }}-{{ build_target }}/mobile/
    - cwd: {{ www_root }}/mobile/deploy
    - user: {{ user }}
    - onlyif: python -c "import sys; sys.exit(0) if '{{ grains['host'] }}' in {{ servers }} else sys.exit(1)"


