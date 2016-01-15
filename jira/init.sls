{%- from 'bitbucket/conf/settings.sls' import bitbucket with context %}

include:
  - sun-java
  - sun-java.env
#  - apache.vhosts.standard
#  - apache.mod_proxy_http

### APPLICATION INSTALL ###
unpack-bitbucket-tarball:
  archive.extracted:
    - name: {{ bitbucket.prefix }}
    - source: {{ bitbucket.source_url }}/atlassian-bitbucket-{{ bitbucket.version }}.tar.gz
    - source_hash: {{ salt['pillar.get']('bitbucket:source_hash', '') }}
    - archive_format: tar
    - user: bitbucket 
    - tar_options: z
    - if_missing: {{ bitbucket.prefix }}/atlassian-bitbucket-{{ bitbucket.version }}-standalone
    - runas: bitbucket
    - keep: True
    - require:
      - module: bitbucket-stop
      - file: bitbucket-init-script
    - listen_in:
      - module: bitbucket-restart

fix-bitbucket-filesystem-permissions:
  file.directory:
    - user: bitbucket
    - recurse:
      - user
    - names:
      - {{ bitbucket.prefix }}/atlassian-bitbucket-{{ bitbucket.version }}-standalone
      - {{ bitbucket.home }}
      - {{ bitbucket.log_root }}
    - watch:
      - archive: unpack-bitbucket-tarball

create-bitbucket-symlink:
  file.symlink:
    - name: {{ bitbucket.prefix }}/bitbucket
    - target: {{ bitbucket.prefix }}/atlassian-bitbucket-{{ bitbucket.version }}-standalone
    - user: bitbucket
    - watch:
      - archive: unpack-bitbucket-tarball

create-logs-symlink:
  file.symlink:
    - name: {{ bitbucket.prefix }}/bitbucket/logs
    - target: {{ bitbucket.log_root }}
    - user: bitbucket
    - backupname: {{ bitbucket.prefix }}/bitbucket/old_logs
    - watch:
      - archive: unpack-bitbucket-tarball

### SERVICE ###
bitbucket-service:
  service.running:
    - name: bitbucket
    - enable: True
    - require:
      - archive: unpack-bitbucket-tarball
      - file: bitbucket-init-script

# used to trigger restarts by other states
bitbucket-restart:
  module.wait:
    - name: service.restart
    - m_name: bitbucket

bitbucket-stop:
  module.wait:
    - name: service.stop
    - m_name: bitbucket  

bitbucket-init-script:
  file.managed:
    - name: '/etc/init.d/bitbucket'
    - source: salt://bitbucket/templates/bitbucket.init.tmpl
    - user: root
    - group: root
    - mode: 0755
    - template: jinja
    - context:
      bitbucket: {{ bitbucket|json }}

### FILES ###
{{ bitbucket.home }}/bitbucket-config.properties:
  file.managed:
    - source: salt://bitbucket/templates/bitbucket-config.properties.tmpl
    - user: {{ bitbucket.user }}
    - template: jinja
    - listen_in:
      - module: bitbucket-restart

{{ bitbucket.home }}/dbconfig.xml:
  file.managed:
    - source: salt://bitbucket/templates/dbconfig.xml.tmpl
    - user: {{ bitbucket.user }}
    - template: jinja
    - listen_in:
      - module: bitbucket-restart

{{ bitbucket.prefix }}/bitbucket/atlassian-bitbucket/WEB-INF/classes/bitbucket-application.properties:
  file.managed:
    - source: salt://bitbucket/templates/bitbucket-application.properties.tmpl
    - user: {{ bitbucket.user }}
    - template: jinja
    - listen_in:
      - module: bitbucket-restart

{{ bitbucket.prefix }}/bitbucket/bin/setenv.sh:
  file.managed:
    - source: salt://bitbucket/templates/setenv.sh.tmpl
    - user: {{ bitbucket.user }}
    - template: jinja
    - mode: 0644
    - listen_in:
      - module: bitbucket-restart

# {{ bitbucket.prefix }}/bitbucket/conf/logging.properties:
#   file.managed:
#     - source: salt://bitbucket/templates/logging.properties.tmpl
#     - user: {{ bitbucket.user }}
#     - template: jinja
#     - watch_in:
#       - module: bitbucket-restart

