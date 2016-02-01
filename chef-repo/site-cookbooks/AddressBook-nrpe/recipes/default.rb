#
# Cookbook Name:: AddressBook-nrpe
# Recipe:: default
#
# Copyright 2016, Francisco Lopez
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nrpe'
include_recipe 'selinux_policy::install'

file "#{node['nrpe']['pid_file']}" do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode  0777
end

nrpe_check "check_load" do
  command "#{node['nrpe']['plugin_dir']}/check_load"
  warning_condition '10'
  critical_condition '15'
  action :add
end

nrpe_check "check_users" do
  command "#{node['nrpe']['plugin_dir']}/check_users"
  warning_condition '5'
  critical_condition '10'
  action :add
end

nrpe_check "check_disk" do
  command "#{node['nrpe']['plugin_dir']}/check_disk"
  warning_condition '20%'
  critical_condition '10%'
  parameters " -A -i .gvfs"
  action :add
end

nrpe_check "check_procs" do
  command "#{node['nrpe']['plugin_dir']}/check_procs"
  warning_condition '$ARG1$'
  critical_condition '$ARG2$'
  action :add
end

nrpe_check "check_swap" do
  command  "#{node['nrpe']['plugin_dir']}/check_swap"
  warning_condition '20'
  critical_condition '10'
  action :add
end

selinux_policy_module 'nrpe' do
  content '
module nrpe 1.0;

require {
        type nagios_system_plugin_t;
        type var_run_t;
        type nrpe_exec_t;
        type nagios_etc_t;
        type nrpe_t;
        type nagios_checkdisk_plugin_t;
        type init_tmp_t;
        type configfs_t;
        class dir getattr;
        class dir read;
        class file { write getattr read open };
}

allow nagios_system_plugin_t nrpe_exec_t:file getattr;
allow nrpe_t init_tmp_t:file write;
allow nrpe_t nagios_etc_t:dir read;
allow nagios_checkdisk_plugin_t configfs_t:dir getattr;
allow nrpe_t nagios_etc_t:file open;
allow nrpe_t nagios_etc_t:file { read getattr };
allow nrpe_t var_run_t:file { read write open };
'
  action :deploy
end

bash "append_to_config" do
   user "nrpe"
   code <<-EOF
   sed -e "/^command/d" "#{node['nrpe']['conf_dir']}/nrpe.cfg" >/tmp/nrpe.cfg

   echo "command[check_disk]=/usr/lib64/nagios/plugins/check_disk -w \\$USER1\\$ -c \\$USER2\\$" >>/tmp/nrpe.cfg
   echo "command[check_load]=/usr/lib64/nagios/plugins/check_load -w \\$USER1\\$ -c \\$USER2\\$" >>/tmp/nrpe.cfg
   echo "command[check_procs]=/usr/lib64/nagios/plugins/check_procs -w \\$USER1\\$ -c \\$USER2\\$" >>/tmp/nrpe.cfg
   echo "command[check_users]=/usr/lib64/nagios/plugins/check_users -w \\$USER1\\$ -c \\$USER2\\$" >>/tmp/nrpe.cfg
   echo "command[check_swap]=/usr/lib64/nagios/plugins/check_swap -w \\$USER1\\$ -c \\$USER2\\$" >>/tmp/nrpe.cfg
   EOF
 end

execute "restart nrpe" do
   command "service nrpe restart"
end
