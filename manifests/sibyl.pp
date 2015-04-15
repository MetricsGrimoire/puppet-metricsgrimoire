# This class installs Sibyl tool.

class sibyl {

# 1. PATH.
$path = ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]

# 2. A new directory to git clone Sibyl repo is created.
	file { "/home/git/Sibyl":
		ensure => "directory"
	}
	
# 3. git clone Sibyl repo.
	vcsrepo { "/home/git/Sibyl":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/Sibyl.git",
		revision => 'master'
	}
	
# 4. Installation of Sibyl (setup.py).
	exec { "install sibyl":
		cwd => "/home/git/Sibyl",
		command => "python setup.py install",
		path => $path,
		require => [ Package["python-setuptools"], Vcsrepo["/home/git/Sibyl"] ]
	}

}
