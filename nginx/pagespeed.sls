nginx-pagespeed:
  pkgrepo.managed:
    - humanname: Doubleleft Repository
    - name: deb http://dl-repo.s3.amazonaws.com vivid main
    - dist: vivid
    - file: /etc/apt/sources.list.d/doubleleft.list
    - key_url: http://dl-devops.s3.amazonaws.com/aline.key
    - require_in:
      - pkg: nginx-pagespeed

  pkg.latest:
    - name: nginx
    - fromrepo: dlrepo

include:
  - nginx
