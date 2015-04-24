{% import "base.sls" as base with context %}

python-docker:
  pkg.installed

saltdocker-test_image:
  docker.built:
    - path: {{ base.www_root }}
    - require:
      - pkg: python-docker

saltdocker_container:
  docker.installed:
    - name: saltdocker-test
    - image: saltdocker-test_image
    - environment:
      - "PORT": "5000"
    - ports:
      - "5000/tcp"
    - require:
      - docker: saltdocker-test_image

saltdocker-running:
  docker.running:
    - container: saltdocker-test
    - ports:
      "5000/tcp":
        HostIp: "0.0.0.0"
        HostPort: "5000"
    - volumes:
      - {{ base.www_root }}: /srv/www/{{ base.proj_name }}
    - require:
      - docker: saltdocker_container
