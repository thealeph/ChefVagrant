#
# Cookbook Name:: AddressBook-firewall
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#

include_recipe "firewall"

firewall 'ufw' do
 # action [ :enable, :save ]
  action [ :save ]
end

firewall_rule 'icmp' do
  protocol :icmp
  position 1
  command :allow
end

firewall_rule 'ssh' do
  port     22
  position 1
  command   :allow
end

# open standard http port to tcp traffic only; insert as first rule
firewall_rule 'http' do
  port     80
  protocol :tcp
  position 1
  command   :allow
end

firewall_rule 'https' do
  port     443
  protocol :tcp
  position 1
  command   :allow
end

firewall_rule 'ncsa' do
  port     5666
  protocol :tcp
  position 1
  command   :allow
end

firewall 'ufw1' do
  action [ :save ]
end

