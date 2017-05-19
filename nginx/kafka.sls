{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/var/www') -%}
{% set source = nginx.get('source_root', '/usr/local/src') -%}



get-librdkafka:
  file.managed:
    - name: {{ librdkafka_package }}
    - source: https://github.com/edenhill/librdkafka/archive/v0.9.5.tar.gz
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ librdkafka_package }} -C {{ home }}
    - watch:
      - file: get-librdkafka

install-librdkafka:
  cmd.wait:
    - cwd: {{ home }}/librdkafka-0.9.5
    - names:
      - ./configure
      - make && make install 
    - watch:
      - cmd: get-librdkafka


get-nginx-kafka:
  file.managed:
    - name: {{ nginx_kafka_package }}
    - source: https://github.com/brg-liuwei/ngx_kafka_module/releases/tag/v0.9.1
  cmd.wait:
    - cwd: {{ source }}
    - name: tar -zxf {{ nginx_kafka_package }} -C {{ home }}
    - watch:
      - file: get-nginx-kafka

install-nginx-kafka:
  cmd.wait:
    - cwd: {{ home }}/ngx_kafka_module-0.9.1
    - names:
      - ./configure
      - make && make install 
    - watch:
      - cmd: get-nginx-kafka


