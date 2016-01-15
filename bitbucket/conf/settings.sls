{% set p  = salt['pillar.get']('bitbucket', {}) %}
{% set g  = salt['grains.get']('bitbucket', {}) %}


{%- set default_version      = '4.3.0' %}
{%- set default_prefix       = '/opt' %}
{%- set default_source_url   = 'https://downloads.atlassian.com/software/stash/downloads' %}
{%- set default_log_root     = '/var/log/bitbucket' %}
{%- set default_bitbucket_user    = 'bitbucket' %}
{%- set default_db_server    = 'localhost' %}
{%- set default_db_name      = 'bitbucket' %}
{%- set default_db_username  = 'bitbucket' %}
{%- set default_db_password  = 'bitbucket' %}
{%- set default_jvm_Xms      = '384m' %}
{%- set default_jvm_Xmx      = '768m' %}
{%- set default_jvm_MaxPermSize = '384m' %}
{%- set default_webserver_fqdn = 'bitbucket.example.com' %}

{%- set version        = g.get('version', p.get('version', default_version)) %}
{%- set source_url     = g.get('source_url', p.get('source_url', default_source_url)) %}
{%- set log_root       = g.get('log_root', p.get('log_root', default_log_root)) %}
{%- set prefix         = g.get('prefix', p.get('prefix', default_prefix)) %}
{%- set bitbucket_user      = g.get('user', p.get('user', default_bitbucket_user)) %}
{%- set db_server      = g.get('db_server', p.get('db_server', default_db_server)) %}
{%- set db_name        = g.get('db_name', p.get('db_name', default_db_name)) %}
{%- set db_username    = g.get('db_username', p.get('db_username', default_db_username)) %}
{%- set db_password    = g.get('db_password', p.get('db_password', default_db_password)) %}
{%- set jvm_Xms        = g.get('jvm_Xms', p.get('jvm_Xms', default_jvm_Xms)) %}
{%- set jvm_Xmx        = g.get('jvm_Xmx', p.get('jvm_Xmx', default_jvm_Xmx)) %}
{%- set jvm_MaxPermSize = g.get('jvm_MaxPermSize', p.get('jvm_MaxPermSize', default_jvm_MaxPermSize)
) %}
{%- set webserver_fqdn = g.get('webserver_fqdn', p.get('webserver_fqdn', default_webserver_fqdn)) %}

{%- set bitbucket_home      = salt['pillar.get']('users:%s:home' % bitbucket_user, '/home/bitbucket') %}

{%- set bitbucket = {} %}
{%- do bitbucket.update( { 'version'        : version,
                      'source_url'     : source_url,
                      'log_root'       : log_root,
                      'home'           : bitbucket_home,
                      'prefix'         : prefix,
                      'user'           : bitbucket_user,
                      'db_server'      : db_server,
                      'db_name'        : db_name,
                      'db_username'    : db_username,
                      'db_password'    : db_password,
                      'jvm_Xms'        : jvm_Xms,
                      'jvm_Xmx'        : jvm_Xmx,
                      'jvm_MaxPermSize': jvm_MaxPermSize,
                      'webserver_fqdn' : webserver_fqdn,
                  }) %}

