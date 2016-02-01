#
# Cookbook Name:: AddressBook-mysql
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#

#
# Implement secret bag to store password
#
mysql_service 'mysqld' do
  port '3306'
  version '5.7'
  initial_root_password 'pancho'
  action [:create]
end
