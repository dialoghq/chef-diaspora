name             'diaspora'
maintainer       'Alexander Wenzowski'
maintainer_email 'alex@ent.io'
license          'Apache 2.0'
description      'Installs/Configures Diaspora'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'apt',                '~> 1.9.0'

# database support
depends 'database',           '~> 1.3.12'
depends 'postgresql',         '~> 2.2.2'
depends 'mysql',              '~> 2.1.2'

# redis
depends 'redisio',            '~> 1.4.1'

# install a modern ruby
depends 'rvm' # from https://github.com/fnichol/chef-rvm

depends 'application',        '~> 2.0.0'
depends 'application_ruby',   '~> 1.1.0'
depends 'application_nginx',  '~> 1.0.2'
depends 'user'

# image manipulation
depends 'imagemagick',        '~> 0.2.2'

# javascript runtime
depends 'nodejs',             '~> 1.1.2'

# export environment variables
depends 'magic_shell',        '~> 0.2.0'

supports 'ubuntu', '= 12.04'

