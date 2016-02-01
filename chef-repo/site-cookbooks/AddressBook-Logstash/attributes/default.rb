#
# Cookbook Name:: Address-Logstash
# Attributes:: default
#
# Author:: Francisco Lopez (<flopez@gmail.com>)
#
default['logstash-forwarder']['logstash_servers']      = ['logstash_server:5004']
default['logstash-forwarder']['timeout']               = '13'
default['logstash-forwarder']['ssl_ca']                 = '/etc/pki/tls/certs/logstash-forwarder.crt'
