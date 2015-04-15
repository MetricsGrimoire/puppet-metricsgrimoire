# This class installs MailingListStats tool.

class mlstats {

# 1. PATH.
$path = ["/usr/local/sbin","/usr/local/bin","/usr/sbin","/usr/bin","/sbin","/bin"]

# 2. A new directory to git clone MailingListStats repo is created.
	file { "/home/git/MailingListStats":
		ensure => "directory"
	}
	
# 3. git clone MailingListStats repo.
	vcsrepo { "/home/git/MailingListStats":
		ensure => present,
		provider => git,
		source => "https://github.com/MetricsGrimoire/MailingListStats.git",
		revision => '3a308fd9a6337ceca0056d6c459c87f4c12e4a55'
	}

# 4. Installation of MailingListStats (setup.py).
	exec { "install mlstats":
		cwd => "/home/git/MailingListStats",
		command => "python setup.py install",
		path => $path,
		require => [ Package["python-setuptools"], Vcsrepo["/home/git/MailingListStats"] ]
	}

}
