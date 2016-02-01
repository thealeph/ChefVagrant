#
# Cookbook Name:: AddressBook-nginx
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'nginx'

template "#{node.nginx.dir}/conf.d/http.conf" do
  source "http.conf"
  mode 0644
  owner node.nginx.user
  group node.nginx.user
end


directory '/var/lib/nginx/cache' do
  owner node.nginx.user
  group node.nginx.user
  mode '0700'
  action :create
end
