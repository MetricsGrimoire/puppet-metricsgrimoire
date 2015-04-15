# Here you import your different nodes.pp and you can define global variables.
import 'nodes.pp'

$puppetmaster = 'puppetmaster.bitergia.com' # puppetmaster.bitergia.com must be changed for your puppetmaster's name.
$mysql_password = 'root' # root must be changed for your current root password.
