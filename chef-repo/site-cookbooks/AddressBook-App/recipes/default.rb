#
# Cookbook Name:: AddressBook-App
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#

AddressBook_db = data_bag_item("AddressBook", "#{node.chef_environment}")

ruby_block "AddressBook-template" do
  action :create
  block do
    t = Chef::Resource::Template.new("#{node.nginx.dir}/sites-enabled/AddressBook", run_context)
    t.mode 0644
    t.source     'AddressBook.erb'
    t.cookbook   'AddressBook-App'
    t.owner      node.nginx.user
    t.group      node.nginx.user
    t.variables  :node_ip => "#{node['ipaddress']}", :site_name => "#{AddressBook_db['AddressBook_host']}", :site_name_alt => "#{AddressBook_db['AddressBook_host_alt']}", :m_site_name => "#{AddressBook_db['m_host']}", :autosuggest_site_name => "#{AddressBook_db['autosuggest_host']}"
    t.run_action :create
  end
end

directory "#{node.nginx.dir}/ssl" do
  mode '0755'
end

template "#{node.nginx.dir}/ssl/wildcard.cer" do
  source "wildcard.cer"
  mode 0644
  owner node.nginx.user
  group node.nginx.user
end

template "#{node.nginx.dir}/ssl/wildcard_unencrypted.key" do
  source "wildcard_unencrypted.key"
  mode 0640
  owner node.nginx.user
  group node.nginx.user
end

user "#{AddressBook_db['app_user']}" do
  comment 'AddressBook User'
  home AddressBook_db['AddressBook_home']
  shell '/bin/false'
end

directory AddressBook_db['AddressBook_home'] do
  mode '0755'
end

directory AddressBook_db['app_path'] do
  owner "#{AddressBook_db['app_user']}"
  group 'root'
  mode '0755'
  action :create
end

bash "append_to_aliases" do
   user "root"
   code <<-EOF
      echo "AddressBook:  #{AddressBook_db['AddressBook_mail']}" >> /etc/aliases
      newaliases
   EOF
   not_if "grep -q \"^AddressBook:\" /etc/aliases"
end

remote_file "#{AddressBook_db['build_local']}" do
  source "#{AddressBook_db['build_source']}"
  owner "#{AddressBook_db['app_user']}"
  group "#{AddressBook_db['app_user']}"
  mode '0644'
  action :create
end

#tar_extract "#{AddressBook_db['build_local']}" do
#  action :extract_local
#  creates "#{AddressBook_db['app_path']}/ALWAYSUNTAR"
#  target_dir "#{AddressBook_db['app_path']}"
#  group "#{AddressBook_db['app_user']}"
#  user "#{AddressBook_db['app_user']}"
#end

bash "Extract Application" do
   user "#{AddressBook_db['app_user']}"
   code <<-EOF
      unzip -d "#{AddressBook_db['app_path']}" "#{AddressBook_db['build_local']}"
   EOF
end

logrotate_app "AddressBook-server" do
  cookbook "logrotate"
  path [ "/var/log/AddressBook/server.log", "/var/log/AddressBook/access.log" ]
  frequency "daily"
  rotate 7
  create "644 root adm"
end

directory '/var/log/AddressBook' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

script 'SELinix policies for logrotate' do
  interpreter "bash"
  code <<-EOH
        semanage fcontext -a -t var_log_t /var/log/AddressBook
        restorecon -v /var/log/AddressBook
    EOH
end

execute "Reload nginx" do
  command "service nginx reload"
end
