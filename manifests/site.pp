# Here you import your different nodes.pp and you can define global variables.

import 'nodes.pp'

# puppetmaster.bitergia.com must be changed for your puppetmaster's name.
$puppetmaster = 'puppetmaster.bitergia.com'
# root must be changed for your current root password.
$mysql_password = 'root'
