#!/usr/bin/env ruby

metadata

cookbook 'rvm', github: 'fnichol/chef-rvm'
cookbook 'application_nginx', github: 'devops-israel/opscode-cookbooks-application_nginx',
                              branch: 'support_unix_sockets'
group :solo do
  cookbook 'chef-solo-search', github: 'edelight/chef-solo-search'
end

