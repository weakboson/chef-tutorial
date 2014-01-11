#
# Cookbook Name:: gem-bundler
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "ruby"

gem_package "bundler" do
  action :install
end
