# This class installs Sibyl tool and all necessary packages to get it.

class sibyl {

# 1. A new directory to git clone Sibyl repo is created.
	file { "/home/git/Sibyl":
		ensure => "directory"
	}
	
# 2. git clone Sibyl repo.
	vcsrepo { "/home/git/Sibyl":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/Sibyl.git",
		revision => 'master'
	}
	
# 3. Installation of Sibyl (setup.py).
	exec { "install sibyl":
		cwd => "/home/git/Sibyl",
		command => "python setup.py install",
		path => $path,
		require => Package["python-setuptools"]
	}

}
