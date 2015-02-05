nginx-pagespeed:
  pkgrepo.managed:
    - humanname: Doubleleft Repository
    - name: deb http://dl-repo.s3.amazonaws.com/dlrepo utopic main
    - dist: utopic-doubleleft
    - file: /etc/apt/sources.list.d/doubleleft.list
    - keyid: 96EF8ADE
    - key_url: http://dl-devops.s3.amazonaws.com/aline.key
    - require_in:
      - pkg: nginx-pagespeed

  pkg.installed:
    - name: nginx
    - fromrepo: utopic-doubleleft

include:
  - nginx
