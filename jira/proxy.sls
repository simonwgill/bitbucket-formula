{%- from 'jira/conf/settings.sls' import jira with context %}

jira-vhost:
  file.managed:
    - name: /etc/httpd/sites-available/jira.conf
    - source: salt://jira/templates/jira-vhost.tmpl
    - template: jinja
    - require:
      - file: sites-available

enable-jira-site:
  file.symlink:
    - name: /etc/httpd/sites-enabled/jira.conf
    - target: /etc/httpd/sites-available/jira.conf
    - listen_in:
      - module: apache-reload
    - require:
      - file: jira-vhost

