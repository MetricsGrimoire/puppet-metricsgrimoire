# This class installs Sortinghat tool.

class sortinghat {

# 1. PATH.
$path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']
# 2. A new directory to git clone Sortinghat repo is created.
  file { '/home/git/Sortinghat':
    ensure => 'directory',
  }
# 3. git clone Sortinghat repo.
  vcsrepo { '/home/git/Sortinghat':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/MetricsGrimoire/sortinghat.git',
    revision => 'master',
  }
# 4. Installation of Sortinghat (setup.py).
  exec { 'install sortinghat':
    cwd     => '/home/git/Sortinghat',
    command => 'python setup.py install',
    path    => $path,
    require => [ Package['python-setuptools'],Package['python-mysqldb'],Package['python-sqlalchemy'],Package['python-jinja2'],Package['python-dateutil'],Vcsrepo['/home/git/Sortinghat'] ],
  }

}
