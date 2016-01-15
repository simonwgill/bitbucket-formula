{%- from 'bitbucket/conf/settings.sls' import bitbucket with context %}


bitbucket-vhost:
  file.managed:
    - name: /etc/httpd/sites-available/bitbucket.conf
    - source: salt://bitbucket/templates/bitbucket.vhost.tmpl
    - template: jinja
    - file: sites-available

enable-bitbucket-site:
  file.symlink:
    - name: /etc/httpd/sites-enabled/bitbucket.conf
    - target: /etc/httpd/sites-available/bitbucket.conf
    - listen_in:
      - module: apache-reload
    - require:
      - file: bitbucket-vhost
