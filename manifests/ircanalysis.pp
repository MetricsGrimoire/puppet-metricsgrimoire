# This class installs IRCAnalysis tool.

class ircanalysis {

# 1. PATH.
$path = ['/usr/local/sbin',\
'/usr/local/bin',\
'/usr/sbin',\
'/usr/bin',\
'/sbin',\
'/bin']
# 2. A new directory to git clone IRCAnalysis repo is created.
  file { '/home/git/IRCAnalysis':
    ensure => 'directory',
  }
# 3. git clone IRCAnalysis repo.
  vcsrepo { '/home/git/IRCAnalysis':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/MetricsGrimoire/IRCAnalysis.git',
    revision => 'master',
  }
# 4. Installation of IRCAnalysis (setup.py).
  exec { 'install ircanalysis':
    cwd     => '/home/git/IRCAnalysis',
    command => 'python setup.py install',
    path    => $path,
    require => [ Package['python-setuptools'],\
Vcsrepo['/home/git/IRCAnalysis'] ],
  }

}
