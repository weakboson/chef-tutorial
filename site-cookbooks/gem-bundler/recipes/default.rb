#
# Cookbook Name:: gem-bundler
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "ruby"

execute 'gem install bundler' do
  user 'root'
  not_if { File.exists? '/usr/bin/bundle' }
end
