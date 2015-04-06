# This class installs MailingListStats tool and all necessary packages to get it.

class mlstats {

# 1. PATH.
	$path = ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]

# 2. First at all, apt-get update.
	exec { "apt-get update":
		user => root,
		path => $path
	}

# 3. Installation and configuration of mysql-server.
class { '::mysql::server':
	old_root_password => 'root',
	root_password => 'root',
	override_options => { root_password => 'root' }
}

# 4. Installation of git package.
	package { "git":
		ensure => installed,
		require => Exec["apt-get update"]
	}

# 5. A new directory to git clone MailingListStats repo is created.
	file { "/home/git/MailingListStats":
		ensure => "directory"
	}

# 6. git clone MailingListStats repo.
	vcsrepo { "/home/git/MailingListStats":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/MailingListStats.git",
		revision => 'master'
	}

# 7. git checkout to back to a previous version.
	exec { "checkout previous version":
		cwd => "/home/git/MailingListStats",
		command => "git checkout 3a308fd9a6337ceca0056d6c459c87f4c12e4a55",
		path => $path
	}

# 8. Installation of python-setup-tools.
	package { "python-setuptools":
		ensure => installed,
		require => Exec["apt-get update"]
	}

# 9. Installation of python-mysqldb.
	package { "python-mysqldb":
		ensure => installed,
		require => Exec["apt-get update"]
	}

# 10. Configuration of mysql-password-root.
	exec { "mysql-password-root":
		subscribe => Package["mysql-server"],
		refreshonly => true,
		unless => "mysqladmin -uroot -p$mysql_password status",
		path => $path,
		command => "mysqladmin -uroot password $mysql_password"
	}

# 11. Installation of postgresql-server.
	package { "postgresql-server":
		ensure => installed,
		require => Exec["apt-get update"]
	}

# 12. Installation of python-psycopg2.
	package { "python-psycopg2":
		ensure => installed,
		require => Exec["apt-get update"]
	}

# 13. Installation of MailingListStats (setup.py).
	exec { "install mlstats":
		cwd => "/home/git/MailingListStats",
		command => "python setup.py install",
		path => $path,
		require => Package["python-setuptools"]
	}

}
