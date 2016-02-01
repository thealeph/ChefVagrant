#
# Cookbook Name:: AddressBook-tomcat
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#
#AddressBook_db = data_bag_item("AddressBook", "#{node.chef_environment}")

node.default['tomcat']['base_version'] = 7

version = node['tomcat']['base_version']

node.default['tomcat']['java_options'] = '-server -Xms1024m -Xmx1024m -XX:MaxPermSize=512m -Djava.awt.headless=true'
node.default['tomcat']['deploy_manager_packages'] = ["tomcat-admin-webapps"]
node.default['tomcat']['base_instance'] = "tomcat"
node.default['tomcat']['packages'] = ["tomcat"]
#node.default['tomcat']['user'] = "#{AddressBook_db['app_user']}"
#node.default['tomcat']['group'] = "#{AddressBook_db['app_user']}"
node.default['tomcat']['home'] = "/usr/share/tomcat"
node.default['tomcat']['base'] = "/var/lib/tomcat"
node.default['tomcat']['config_dir'] = "/etc/tomcat"
node.default['tomcat']['log_dir'] = "/var/log/tomcat"
node.default['tomcat']['tmp_dir'] = "/tmp/tomcat"
node.default['tomcat']['work_dir'] = "/var/cache/tomcat"
node.default['tomcat']['context_dir'] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
node.default['tomcat']['webapp_dir'] = "/var/lib/tomcat/webapps"
node.default['tomcat']['keytool'] = 'keytool'
node.default['tomcat']['lib_dir'] = "#{node["tomcat"]["home"]}/lib"
node.default['tomcat']['endorsed_dir'] = "#{node["tomcat"]["lib_dir"]}/endorsed"
node.default['tomcat']['port'] = 9000

directory "#{node.default['tomcat']['base']}" do
  mode '0777'
end

include_recipe 'tomcat'

directory "#{node.default['tomcat']['base']}" do
  mode '0755'
  owner 'tomcat'
  group 'tomcat'
end

directory "#{node.default['tomcat']['base']}/logs" do
  mode '0755'
  owner 'tomcat'
  group 'tomcat'
end

bash "Fix Tomcat missing config" do
   user "root"
   code <<-EOF
      ln -s /etc/tomcat "#{node.default['tomcat']['base']}/conf"
      service tomcat start
   EOF
   not_if "grep -q \"^AddressBook:\" /etc/aliases"
end
