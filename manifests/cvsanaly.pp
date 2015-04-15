# This class installs CVSAnalY tool.

class cvsanaly {

# 1. PATH.
$path = ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]

# 2. A new directory to git clone CVSAnaly repo is created.
	file { "/home/git/CVSAnalY":
		ensure => "directory"
	}
	
# 3. A new directory to git clone RepositoryHandler repo is created.
	file { "/home/git/RepositoryHandler":
		ensure => "directory"
	}

# 4. git clone CVSAnaly repo.
	vcsrepo { "/home/git/CVSAnalY":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/CVSAnalY.git",
		revision => 'master'
	}
	
# 5. git clone RepositoryHandler repo.
	vcsrepo { "/home/git/RepositoryHandler":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/RepositoryHandler.git",
		revision => 'master'
	}

# 6. Installation of repositoryHandler (setup.py).
	exec { "install repositoryhandler":
		cwd => "/home/git/RepositoryHandler",
		command => "python setup.py install",
		path => $path,
		require => [ Package["python-setuptools"], Vcsrepo["/home/git/RepositoryHandler"] ]
	}

# 7. Installation of CVSAnalY (setup.py).
	exec { "install cvsanaly":
		cwd => "/home/git/CVSAnalY",
		command => "python setup.py install",
		path => $path,
		require => [ Package["python-setuptools"], Vcsrepo["/home/git/CVSAnalY"] ]
	}

}
