include:
  - modules.database.redis.install

slave-trasfer-files:
  file.managed:
  - names:
    - {{ pillar['redis_install_dir'] }}/conf/redis.conf:
      - source: salt://redis-master-slave/files/redis.conf.j2
  - template: jinja

'systemctl restart redis_server':
  cmd.run

{{ pillar['redis_install_dir'] }}/bin/redis-cli REPLICAOF {{ pillar['redis_master_ip'] }} {{ pillar['redis_prod'] }}:
  cmd.run
