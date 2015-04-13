# This class installs MetricsGrimoire tools and all necessary packages to get it.

class { 'metricsgrimoire':
	include cvsanaly,
        include mlstats,
        include sibyl
}
