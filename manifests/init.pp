# This class installs the complete package of tools and all you need to install them.

class quick-start {

# 1. PATH.
$path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']
# 2. File .my.cnf (needed to connect to the mysql bbdd without password).
  exec {"echo \"[client]\nuser=root\nhost=localhost\npassword=\'$mysql_password\'\" > /root/.my.cnf":
    user => root,
    path => $path,
  }
# 3. First at all, apt-get update.
  exec { 'apt-get update':
    user => root,
    path => $path,
  }
# 4. Installation of mysql-server.
class { '::mysql::server':
  old_root_password => 'root',
  root_password     => 'root',
  override_options  => { root_password => 'root' },
}
# 5. Installation of mysql-client.
class { '::mysql::client': }
# 6. A new mysql-ddbb and mysql-user are created.
mysql::db { 'testdb':
  user     => 'usertest',
  password => 'usertest',
  grant    => 'ALL',
}
# 7. Installation of git package.
  package { 'git':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 8. Installation of python-setuptools (needed for cvsanaly).
  package { 'python-setuptools':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 9. Installation of python-mysqldb (needed for cvsanaly).
  package { 'python-mysqldb':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 10. Configuration of mysql-password-root.
  exec { 'mysql-password-root':
    subscribe   => [ Package['mysql-client'], Package['mysql-server'] ],
    refreshonly => true,
    unless      => 'mysqladmin -uroot -p$mysql_password status',
    path        => $path,
    command     => 'mysqladmin -uroot password $mysql_password',
  }
# 11. Installation of postgresql-server (needed for mlstats).
  package { 'postgresql-9.1':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 12. Installation of python-psycopg2 (needed for mlstats).
  package { 'python-psycopg2':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 13. Installation of python-sqlalchemy (needed for sibyl).
  package { 'python-sqlalchemy':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 14. Installation of python-jinja2 (needed for sortinghat).
  package { 'python-jinja2':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 15. Installation of python-dateutil (needed for sortinghat).
  package { 'python-dateutil':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 16. Directory where tools will be installed
  file { '/home/git':
    ensure => 'directory',
  }
# 17. Installation of python-requests (needed for sibyl).
  package { 'python-requests':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 18. Installation of python-beautifulsoup (needed for sibyl).
  package { 'python-beautifulsoup':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 19. CVSAnalY tool.
  include cvsanaly
# 20. MailingListStats tool.
  include mlstats
# 21. Sibyl tool.
  include sibyl
# 22. Bicho tool.
  include bicho
# 23. IRCAnalysis tool.
  include ircanalysis
# 24. Sortinghat tool.
  include sortinghat

}
