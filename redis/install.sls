dep-redis-pkg-install:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - make
      - tcl-devel
      - systemd-devel

unzip-redis:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/database/redis/files/redis-{{ pillar['redis_version'] }}.tar.gz
    - if_missing: /usr/src/redis-{{ pillar['redis_version'] }}


redis-install:
  cmd.script:
    - name: salt://modules/database/redis/files/install.sh.j2
    - template: jinja
    - require:
      - archive: unzip-redis

{{ pillar['redis_install_dir'] }}/conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makefirs: true

{{ pillar['redis_install_dir'] }}/conf/redis.conf:
  file.managed:
    - source: salt://modules/database/redis/files/redis.conf.j2
    - template: jinja

/usr/lib/systemd/system/redis_server.service:
  file.managed:
    - source: salt://modules/database/redis/files/redis_server.service.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

redis_server.service:
  service.running:
    - enable: true
    - reload: true
