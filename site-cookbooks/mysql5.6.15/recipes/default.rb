#
# Cookbook Name:: mysql5.6.15
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "expect"

VER_RPM = '5.6.15-1.linux_glibc2.5.x86_64.rpm'

rpms = [
        {
          :rpm => "MySQL-server-#{VER_RPM}",
          :package => 'MySQL-server',
          :checksum => '7d1b3d9ddf2c0d60e7d89e405c83cefd896117f03f4aecffbaea0c4315865953'
        }, {
          :rpm => "MySQL-client-#{VER_RPM}",
          :package => 'MySQL-client',
          :checksum => '6eac18f4111e3828ba5833b5444b0c462cc0233340f7fbbfcf9f11a6e98db8a7'
        }, {
          :rpm => "MySQL-shared-compat-#{VER_RPM}",
          :package => 'MySQL-shared-compat',
          :checksum => '9c0f8067808b2f2c4b88511cc012915f52b80f16696570e836ab55dcbb55f20d'
        }, {
          :rpm => "MySQL-shared-#{VER_RPM}",
          :package => 'MySQL-shared',
          :checksum => '26445e769c8171526a5bcd8043511a47ef7db46dd10f8a7a4fb7ad66d56e7c43'
        }
       ]

rpms.each do |r|
  cookbook_file "/tmp/#{r[:rpm]}" do
    source r[:rpm]
    checksum r[:checksum]
  end
end

package (r = rpms.find{ |r| r[:package] =~ /-compat\z/ })[:package] do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{r[:rpm]}"
end

rpms.select{ |r| r[:package] !=~ /-compat\z/ }.each do |r|
  package r[:package] do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{r[:rpm]}"
  end
end

template '/usr/my.cnf' do
  user 'root'
  group 'root'
  mode 0644
  variables(:character_set_server => node['mysql']['character_set_server'],
            :innodb_buffer_pool_size => node['mysql']['innodb_buffer_pool_size'],
            :max_connections => node['mysql']['max_connections'])
end

service 'mysql' do
  action [ :enable, :start ]
end

template '/tmp/change_passwd.sh' do
  only_if 'ls /root/.mysql_secret'
  user 'root'
  group 'root'
  mode '0700'
  variables :root_passwd => node['mysql']['root_passwd']
end

execute '/tmp/change_passwd.sh' do
  only_if 'ls /root/.mysql_secret'
  user 'root'
  command "/tmp/change_passwd.sh && rm /tmp/change_passwd.sh"
end

template '/tmp/mysql_secure_installation.sh' do
  only_if 'ls /root/.mysql_secret'
  user 'root'
  group 'root'
  mode '0700'
  variables :root_passwd => node['mysql']['root_passwd']
end

execute '/tmp/mysql_secure_installation.sh' do
  only_if 'ls /root/.mysql_secret'
  user 'root'
  command "/tmp/mysql_secure_installation.sh && rm /tmp/mysql_secure_installation.sh && rm /root/.mysql_secret"
end
