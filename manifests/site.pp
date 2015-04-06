# Here you import your different nodes.pp and you can define global variables.
import 'nodes.pp'

$puppetmaster = 'test1.domain.test1' # test1.domain.test1 must be changed for your puppetmaster's name.
$mysql_password = 'root' # root must be changed for your current root password.
