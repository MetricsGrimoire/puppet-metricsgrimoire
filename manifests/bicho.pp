# This class installs Bicho tool.

class bicho {

# 1. PATH.
$path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']
# 2. A new directory to git clone Bicho repo is created.
  file { '/home/git/Bicho':
    ensure => 'directory',
  }
# 3. git clone Bicho repo.
  vcsrepo { '/home/git/Bicho':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/MetricsGrimoire/Bicho.git',
    revision => 'master',
  }
# 4. Installation of Bicho (setup.py).
  exec { 'install bicho':
    cwd     => '/home/git/Bicho',
    command => 'python setup.py install',
    path    => $path,
    require => [ Package['python-setuptools'], Vcsrepo['/home/git/Bicho'] ],
  }

}
