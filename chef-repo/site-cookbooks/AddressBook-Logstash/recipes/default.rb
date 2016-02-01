#
# Cookbook Name:: AddressBook-Logstash
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'logstash-forwarder'

template "/etc/pki/tls/certs/logstash-forwarder.crt" do
  source "logstash-forwarder.crt"
  mode 0644
  owner "root"
  group "root"
end

log_forward 'AddressBookLog' do
   paths [ "/var/log/AddressBook/server.log" ]
   fields  "type" => "AddressBookApp"
end

log_forward 'AddressBoookAccessLog' do
   paths [ "/var/log/AddressBook/access.log" ]
   fields  "type" => "AddressBookAccess"
end

