{%- from 'bitbucket/conf/settings.sls' import bitbucket with context %}


apache:
  pkg.installed:
    - pkgs:
       - apache2
  service.running:
    - name: apache2
    - enable: True
    - require:
      - pkg: apache

apache-restart:
  module.wait:
    - name: service.restart
    - m_name: apache2

apache-reload:
  module.wait:
    - name: service.reload
    - m_name: apache2

bitbucket-vhost:
  file.managed:
    - name: /etc/apache2/sites-available/bitbucket
    - source: salt://bitbucket/templates/bitbucket-vhost.tmpl

disable-default-site:
  file.absent:
    - name: /etc/apache2/sites-enabled/000-default
    - listen_in:
      - module: apache-reload
    - require:
      - file: enable-bitbucket-site

enable-bitbucket-site:
  file.symlink:
    - name: /etc/apache2/sites-enabled/bitbucket
    - target: /etc/apache2/sites-available/bitbucket
    - listen_in:
      - module: apache-reload
    - require:
      - file: bitbucket-vhost
 
a2enmod proxy:
  cmd.wait:
    - watch:
      - pkg: apache
    - listen_in:
      - module: apache-restart

a2enmod proxy_http:
  cmd.wait:
    - watch:
      - pkg: apache
    - listen_in:
      - module: apache-restart
