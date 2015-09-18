# This class installs Automator tool.

class automator {

# 1. PATH and HOME.
$path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']
$home = '/home/git/Automator/openstack/cache'
# 2. A new directory to git clone Automator repo is created.
  file { '/home/git/Automator':
    ensure  => 'directory',
    require => Class['quick-start'],
  }
# 3. git clone Automator repo.
  vcsrepo { '/home/git/Automator':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/MetricsGrimoire/Automator.git',
    revision => 'master',
    require  => File['/home/git/Automator'],
  }
# 4. automator-2-puppet-automator
  exec { 'automator2puppet':
    cwd     => '/home/git',
    user    => root,
    command => 'python /home/dpose/automator2puppet-automator.py',
    path    => $path,
    require => Vcsrepo['/home/git/Automator'],
  }
# 5. install python-yaml
  package { 'python-yaml':
    ensure  => installed,
    require => Exec['apt-get update'],
  }
# 6. download file get_repos_and_openstack_conf.py
  file { '/home/git/VizGrimoireUtils':
    ensure  => 'directory',
    require => Vcsrepo['/home/git/Automator'],
  }
  vcsrepo { '/home/git/VizGrimoireUtils':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/VizGrimoire/VizGrimoireUtils.git',
    revision => 'master',
    require  => File['/home/git/VizGrimoireUtils'],
  }
  exec { 'get repos':
    cwd     => '/home/git',
    user    => root,
    command => 'cp VizGrimoireUtils/openstack/get_repos_and_openstack_conf.py Automator/ && chmod a+x Automator/get_repos_and_openstack_conf.py',
    path    => $path,
    require => Vcsrepo['/home/git/VizGrimoireUtils'],
  }
# 7. get repos and create openstack.conf file
  exec { 'launch get-repos':
    cwd     => '/home/git/Automator',
    command => 'python get_repos_and_openstack_conf.py',
    path    => $path,
    require => [ Package['python-yaml'], Exec['get repos'] ],
  }
# 8. create-projects
  exec { 'launch create projects':
    cwd     => '/home/git/Automator/',
    command => 'python create_projects.py -p openstack.conf -d /home/git/Automator/ -s -n openstack --dbuser=root --dbpasswd=root',
    path    => $path,
    timeout => 3600,
    require => [ Class['quick-start'], Vcsrepo['/home/git/Automator'], Exec['launch get-repos'], Exec['automator2puppet'] ],
  }
  file { '/home/git/Automator/openstack/cache':
    ensure  => 'directory',
    require => Exec['launch create projects'],
  }
# 9. main.conf
  exec { 'main.conf':
    cwd     => '/home/git/Automator/',
    #command => 'cp /home/dpose/main.conf /home/git/Automator/openstack/conf/ && rm /home/git/Automator/openstack/tools/GrimoireLib/vizgrimoire/GrimoireUtils.py && cp /home/dpose/GrimoireUtils.py /home/git/Automator/openstack/tools/GrimoireLib/vizgrimoire/GrimoireUtils.py',
    command => 'cp /home/git/VizGrimoireUtils/openstack/main.conf /home/git/Automator/openstack/conf/',
    path    => $path,
    require => Exec['launch create projects'],
  }
# 10. sortinghat init
  exec { 'sortinghat init':
    cwd     => '/home/git/Automator/',
    command => 'sortinghat init cp_sortinghat_openstack',
    path    => $path,
    timeout => 3600,
    require => Exec['main.conf'],
  }
# 11. launch.py -s check_dbs
  exec { 'launch.py -s check-dbs':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s check-dbs',
    path        => $path,
    timeout     => 3600,
    require     => Exec['sortinghat init'],
  }
# 12. launch.py -s cvsanaly
  exec { 'launch.py -s cvsanaly':
    environment => ["HOME=$home"],
    cwd         => '/home/git/Automator/',
    user        => root,
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s cvsanaly',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s check-dbs'],
  }
# 13. launch.py -s mlstats
  exec { 'launch.py -s mlstats':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s mlstats',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s cvsanaly'],
  }
# 14. launch.py -s bicho
  exec { 'launch.py -s bicho':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s bicho',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s mlstats'],
  }
# 15. launch.py -s gerrit
  exec { 'launch.py -s gerrit':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s gerrit',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s bicho'],
  }
# 16. launch.py -s irc
  exec { 'launch.py -s irc':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s irc',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s gerrit'],
  }
# 17. launch.py -s sibyl
  exec { 'launch.py -s sibyl':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s sibyl',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s irc'],
  }
# 18. launch.py -s sortinghat
  exec { 'launch.py -s sortinghat':
    cwd         => '/home/git/Automator/',
    environment => ["HOME=$home"],
    command     => 'python launch.py -d /home/git/Automator/openstack/ -s sortinghat',
    path        => $path,
    timeout     => 36000,
    require     => Exec['launch.py -s sibyl'],
  }

}
