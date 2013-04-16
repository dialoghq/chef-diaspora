#
# Cookbook Name:: diaspora
# Recipe:: db
#
# Copyright (C) 2013 Alexander Wenzowski <alex@ent.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/application' # TODO review hack following [CHEF-3407] resolution 

# Set a secure default password {{{
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
if Chef::Config[:solo]
  if node['diaspora']['db']['password'].nil? || node['diaspora']['db']['password'].empty?
    Chef::Application.fatal! "You must set node['diaspora']['db']['password'] manually in chef-solo mode."
  end
else
  node.set_unless['diaspora']['db']['password'] = secure_password
end
# }}}

# Provision a supported database {{{
case node['diaspora']['db']['provider']
when 'mysql'
  include_recipe 'mysql::server'
  include_recipe 'mysql::ruby'
  connection_info = {
    :username => 'root',
    :password => node['mysql']['server_root_password'],
    :host     => node['diaspora']['db']['host']
  }
  db_provider_class = Chef::Provider::Database::Mysql
  db_user_provider_class = Chef::Provider::Database::MysqlUser
when 'postgres'
  include_recipe 'postgresql::server'
  include_recipe 'postgresql::ruby'
  connection_info = {
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres'],
    :host     => node['diaspora']['db']['host']
  }
  db_provider_class = Chef::Provider::Database::Postgresql
  db_user_provider_class = Chef::Provider::Database::PostgresqlUser
else
  Chef::Application.fatal! 'The database provider must be either mysql or postgres'
end
# }}}

# Provision application database and user with the selected provider {{{
database node['diaspora']['db']['name'] do
  connection connection_info
  provider db_provider_class
  action :create
end

database_user node['diaspora']['db']['username'] do
  connection connection_info
  password node['diaspora']['db']['password']
  provider db_user_provider_class
  database_name node['diaspora']['db']['name']
  privileges [:all]
  action :grant
end
# }}}

