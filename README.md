# MetricsGrimoire puppet-metricsgrimoire

David Pose Fernández <dpfdavid@gmail.com>

This module installs MetricsGrimoire tools.

# Quick Start

	class { 'quick-start':
		include cvsanaly,
		include mlstats,
		include sibyl,
		include bicho,
		include ircanalysis
	}

# Configuration

The MetricsGrimoire puppet module is separated into individual components which MetricsGrimoire needs to run.

## ::CVSAnaly

This module installs CVSAnalY tool. This tool updates git repositories and run CVSAnalY to update git related information.

	class { 'cvsanaly':
	}

## ::MLStats

This module installs MLStats tool. This tool updates mailing lists information system related information.

	class { 'mlstats':
	}
