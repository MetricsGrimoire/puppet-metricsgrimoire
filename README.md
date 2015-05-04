# MetricsGrimoire puppet-metricsgrimoire

David Pose Fernández <dpfdavid@gmail.com>

This module installs MetricsGrimoire tools.

# Quick Start (init.pp file)

This class installs the next tools: CVSAnaly, MLStats, Sibyl, Bicho and IRCAnalysis.

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

## ::Sibyl

This module installs Sibyl tool. Sibyl retrieves information from the Askbot site of OpenStack at http://ask.openstack.org/. This is later stored in a MySQL database.

	class { 'sibyl':
	}

## ::Bicho

This module installs Bicho tool. This tool is used for several purposes:

	class { 'bicho':
	}

## ::IRCAnalysis

This module installs IRCAnalysis tool. This is a simple Python based script that parses log information. This is retrieved from http://eavesdrop.openstack.org/irclogs/.

	class {'ircanalysis':
	}
