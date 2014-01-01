#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
filename = "ruby-2.1.0-2.el6.x86_64.rpm"
file_checksum = "da22c17bf7cdc92559f0939c397d581cec0639c36ebe67fa5fe3cd7ae8d7b36d"

cookbook_file "/tmp/#{filename}" do
  source "#{filename}"
  checksum "#{file_checksum}"
end

package "ruby" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{filename}"
end
