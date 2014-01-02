#
# Cookbook Name:: mysql5.6.15
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# remove old version lib
package 'mysql-libs' do
  action :remove
  version "5.1.71"
end

server = "MySQL-server-5.6.15-1.linux_glibc2.5.x86_64.rpm"
server_checksum = "7d1b3d9ddf2c0d60e7d89e405c83cefd896117f03f4aecffbaea0c4315865953"

client = "MySQL-client-5.6.15-1.linux_glibc2.5.x86_64.rpm"
client_checksum = "6eac18f4111e3828ba5833b5444b0c462cc0233340f7fbbfcf9f11a6e98db8a7"

cookbook_file "/tmp/#{server}" do
  source server
  checksum server_checksum
end

cookbook_file "/tmp/#{client}" do
  source client
  checksum client_checksum
end

package "mysql::server" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{server}"
end

package "mysql::client" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{client}"
end

script "/usr/bin/mysql_install_db" do
end
