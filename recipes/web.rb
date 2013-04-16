#
# Cookbook Name:: diaspora
# Recipe:: web
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

require 'yaml'

# required for typhoeus gem
package 'libcurl4-openssl-dev' do
  action :install
end

# enable connection to db
include_recipe 'postgresql::client'
include_recipe 'mysql::client'

# enable image manipulation
include_recipe 'imagemagick::devel'

# install a javascript runtime for rails 3
include_recipe 'nodejs::install_from_binary'

# we create new user that will run our application server
user_account node['diaspora']['user'] do
  create_group true
  ssh_keygen false
end

include_recipe 'runit'

# configure diaspora
magic_shell_environment 'DB' do
  value node['diaspora']['db']['provider']
end

database_params = {
  :adapter  => node['diaspora']['db']['adapter'],
  :database => node['diaspora']['db']['name'],
  :host     => node['diaspora']['db']['host'],
  :username => node['diaspora']['db']['username'],
  :password => node['diaspora']['db']['password']
}

# install the app
application node['diaspora']['full_env_name'] do
  path node['diaspora']['path']
  owner node['diaspora']['user']
  group node['diaspora']['user']

  repository node['diaspora']['repo_url']
  revision node['diaspora']['repo_ref']

  before_deploy do
    directory '/var/run/unicorn' do
      owner node['diaspora']['user']
      group node['diaspora']['user']
      mode '755'
      recursive true
      action :create
    end

    directory "#{node['diaspora']['path']}/shared/public_assets" do
      owner node['diaspora']['user']
      group node['diaspora']['user']
      mode '755'
      recursive true
      action :create
    end

    file "#{node['diaspora']['path']}/shared/diaspora.yml" do
      owner node['diaspora']['user']
      group node['diaspora']['user']
      mode '0644'
      content node['diaspora']['yaml'].to_yaml
    end
  end

  symlink_before_migrate 'diaspora.yml' => 'config/diaspora.yml',
                         'public_assets' => 'public/assets'
  symlinks 'diaspora.yml' => 'config/diaspora.yml'
  migrate true

  rails do
    bundler true
    bundler_deployment true
    bundler_without_groups %w(heroku postgres)
    bundle_command node['diaspora']['bundle_cmd']
    precompile_assets true

    database do
      database_params.each do |key, value|
        send(key.to_sym, value)
      end
    end
  end

  unicorn do
    preload_app true
    bundler true
    bundle_command node['diaspora']['bundle_cmd']
    port node['diaspora']['socket_file']
  end

  nginx_load_balancer do
    application_socket node['diaspora']['socket_file']
    static_files '/assets' => 'public/assets'
  end

  # For testing purposes
  #action :force_deploy
end

