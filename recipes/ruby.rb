#
# Cookbook Name:: diaspora
# Recipe:: ruby
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

include_recipe 'rvm::system_install'

rvm_environment node['diaspora']['full_env_name']

rvm_wrapper node['diaspora']['full_env_name'] do
  ruby_string node['diaspora']['ruby_string']
  binary 'bundle'
end

