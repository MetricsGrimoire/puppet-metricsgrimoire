<%# This class installs CVSAnalY tool and all necessary packages to get it. %>

class cvsanaly {

<%# 1. PATH and .my.cnf file (necessary to connect to mysql ddbb without pass). %>
	$path = ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]

	file { "/root/.my.cnf":
                ensure => "present",
		owner => root,
    		group => root,
    		mode => 644
        }

	exec { "echo [client] > /root/.my.cnf":
		user ==> root,
		path ==> $path
	}

	exec { "echo user=root >> /root/.my.cnf":
		user ==> root,
		path ==> $path
	}

	exec { "echo host=localhost >> /root/.my.cnf":
		user ==> root,
		path ==> $path
	}

	exec { "echo password=\'$mysql_password\'":
		user ==> root,
                path ==> $path
	} 

<%# 2. First at all, apt-get update. %>
	exec { "apt-get update":
		user => root,
		path => $path
	}

<%# 3. Installation and configuration of mysql-server. %>
	class { '::mysql::server':
		old_root_password => $mysql_password,
		root_password => $mysql_password,
		override_options => { root_password => $mysql_password }
	}

<%# 4. Installation of mysql-client. %>
	class { '::mysql::client': }

<%# 5. A new mysql-ddbb and mysql-user are created. %>
	mysql::db { 'testdb':
		user => 'usertest',
		password => 'usertest',
		grant => 'ALL'
	}

<%# 6. Installation of git package. %>
	package { "git":
		ensure => installed,
		require => Exec["apt-get update"]
	}

<%# 7. A new directory to git clone CVSAnaly repo is created. %>
	file { "/home/git/CVSAnalY":
		ensure => "directory"
	}
	
<%# 8. A new directory to git clone RepositoryHandler repo is created. %>
	file { "/home/git/RepositoryHandler":
		ensure => "directory"
	}

<%# 9. git clone CVSAnaly repo. %>
	vcsrepo { "/home/git/CVSAnalY":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/CVSAnalY.git",
		revision => 'master'
	}
	
<%# 10. git clone RepositoryHandler repo. %>
	vcsrepo { "/home/git/RepositoryHandler":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/RepositoryHandler.git",
		revision => 'master'
	}

<%# 11. Installation of repositoryHandler (setup.py). %>
	exec { "install repositoryhandler":
		cwd => "/home/git/RepositoryHandler",
		command => "python setup.py install",
		path => $path
	}

<%# 12. Installtion of python-setup-tools (needed for cvsanaly). %>
	package { "python-setuptools":
		ensure => installed,
		require => Exec["apt-get update"]
	}

<%# 13. Installation of CVSAnalY (setup.py). %>
	exec { "install cvsanaly":
		cwd => "/home/git/CVSAnalY",
		command => "python setup.py install",
		path => $path,
		require => Package["python-setuptools"]
	}

<%# 14. Installation of python-mysqldb (needed for cvsanaly). %>
	package { "python-mysqldb":
		ensure => installed,
		require => Exec["apt-get update"]
	}

<%# 15. Configuration of mysql-password-root. %>
	exec { "mysql-password-root":
		subscribe => [ Package["mysql-client"], Package["mysql-server"] ],
		refreshonly => true,
		unless => "mysqladmin -uroot -p$mysql_password status",
		path => $path,
		command => "mysqladmin -uroot password $mysql_password"
	}

}
