#
# Cookbook Name:: myredis
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#epelRPM = node['myredis']['epel']
#remote_file "#{Chef::Config[:file_cache_path]}/#{epelRPM}" do
#   action :create_if_missing
#   source node['myredis']['epelurl']
#   mode "0755"
#end

#rpm_package epelRPM do
#  action :install
#  source "#{Chef::Config[:file_cache_path]}/#{epelRPM}"
#end
cookbook_file "/tmp/hardenscript.sh" do
  source "hardenscript.sh"
  mode 0755
end

execute "security_hardening" do
  command "sh /tmp/hardenscript.sh"
end


remiRPM = node['myredis']['remi']
remote_file "#{Chef::Config[:file_cache_path]}/#{remiRPM}" do
    action :create_if_missing
    source node['myredis']['remiurl']
    mode "0755"
end

rpm_package remiRPM do
 action :install
 source "#{Chef::Config[:file_cache_path]}/#{remiRPM}"
end

execute 'enable_repo_remi' do
command "yum -y --enablerepo=remi,remi-test install redis"
action :run
end

ruby_block "insert_line_to_sysctl" do
    block do
		f = Chef::Util::FileEdit.new('/etc/sysctl.conf')
		f.insert_line_if_no_match("/vm.overcommit_memory=1/", "vm.overcommit_memory=1")
		f.insert_line_if_no_match("/net.core.somaxconn=65535/", "net.core.somaxconn=65535")
    f.write_file
	end
end

bash 'config_system' do
  code <<-EOH
    sysctl vm.overcommit_memory=1
    sysctl -w fs.file-max=100000
    EOH
end

template '/etc/redis.conf' do
  source 'redis.conf.erb'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :restart, 'service[redis]', :immediate
  variables({
     :myredis_nodes_ipaddress => node['ipaddress'],
     :myredis_port => node['myredis']['port'],
	   :myredis_master_ipaddress => node['myredis']['master']['ipaddress']
  })
end


template '/etc/redis-sentinel.conf' do
  source 'redis-sentinel.conf.erb'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :restart, 'service[redis]', :immediate
  variables({
   :myredis_nodes_ipaddress => node['ipaddress'],
	 :myredis_sentinel_cluster_name => node['myredis']['sentinel']['cluster_name'],
   :myredis_port => node['myredis']['port'],  
   :myredis_sentinel_quarum => node['myredis']['sentinel']['quarum'],
	 :myredis_master_ipaddress => node['myredis']['master']['ipaddress'],
	 :myredis_sentinel_port => node['myredis']['sentinel']['port']
  })
end

service 'redis' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

execute 'starting_sentinel' do
command "redis-sentinel /etc/redis-sentinel.conf"
action :run
end
