#
# Cookbook Name:: diaspora
# Attributes:: default
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

# TODO find out if this is only necessary with chef-solo
force_default['nginx']['default_site_enabled'] = false

# Do our best to install binary rubies. See wayneeseguin/rvm#1814
default['rvm']['rvmrc']['rvm_max_time_flag'] = 30

default['diaspora']['app_name'] = 'diaspora'
default['diaspora']['rack_env'] = 'production'
default['diaspora']['ruby']     = 'ruby-1.9.3-p392'
default['diaspora']['rubygems'] = '1.8.25'
default['diaspora']['bundler']  = '1.2.5'
default['diaspora']['repo_url'] = 'https://github.com/instrumentio/diaspora.git'
default['diaspora']['repo_ref'] = 'feature/turbo'

default['diaspora']['full_env_name']  = "#{node['diaspora']['app_name']}_#{node['diaspora']['rack_env']}"
default['diaspora']['bundle_cmd']     = "#{node['rvm']['root_path']}/bin/#{node['diaspora']['full_env_name']}_bundle"
default['diaspora']['ruby_string']    = "#{node['diaspora']['ruby']}@#{node['diaspora']['full_env_name']}"
default['diaspora']['user']           = node['diaspora']['full_env_name']
default['diaspora']['path']           = "/home/#{node['diaspora']['user']}"
default['diaspora']['socket_file']    = "/var/run/unicorn/#{node['diaspora']['full_env_name']}.sock"

default['diaspora']['db']['provider'] = 'mysql'
default['diaspora']['db']['host']     = 'localhost'
default['diaspora']['db']['name']     = node['diaspora']['full_env_name']
default['diaspora']['db']['username'] = node['diaspora']['db']['name'][0..15]
default['diaspora']['db']['adapter']  = 'mysql2' # TODO infer from provider

default['diaspora']['yaml']['configuration']['environment']['s3']['enable'] = false
default['diaspora']['yaml']['configuration']['environment']['assets']['serve'] = false
default['diaspora']['yaml']['configuration']['server']['rails_environment'] = node['diaspora']['rack_env']
default['diaspora']['yaml']['configuration']['privacy']['piwik']['enable'] = false
default['diaspora']['yaml']['configuration']['settings']['invitations']['open'] = true
default['diaspora']['yaml']['configuration']['settings']['community_spotlight']['enable'] = false
default['diaspora']['yaml']['configuration']['mail']['enable'] = false
default['diaspora']['yaml']['configuration']['mail']['smtp'] = {}
default['diaspora']['yaml']['configuration']['mail']['sendmail'] = {}
default['diaspora']['yaml']['configuration']['services']['facebook']['enable'] = false
default['diaspora']['yaml']['configuration']['services']['twitter']['enable'] = false
default['diaspora']['yaml']['configuration']['services']['tumblr']['enable'] = false
default['diaspora']['yaml']['configuration']['admins'] = {}
default['diaspora']['yaml']['production'] = {}
default['diaspora']['yaml']['development']['environment'] = {}

if platform_family?('debian', 'arch', 'gentoo')
  default['diaspora']['yaml']['configuration']['certificate_authorities'] = '/etc/ssl/certs/ca-certificates.crt'
elsif platform_family?('rhel', 'fedora')
  default['diaspora']['configuration']['certificate_authorities'] = '/etc/pki/tls/certs/ca-bundle.crt'
end

