:title: Metrics Grimoire Architecture

Metrics Grimoire
################

Metrics Grimoire is a toolset focused on retrieving software development
information from publicly available data sources.

At a Glance
===========

:Hosts:
 * https://activity.openstack.org/dash/
:Puppet:
 * :file:`CVSAnalY/cvsanaly.pp`
:Projects:
 * https://github.com/MetricsGrimoire

Overview
========

The site https://activity.openstack.org/dash is based on the information retrieved
by Metrics Grimoire toolset. 

System Architecture
===================

These are the tools that are used in the information retrieval process:

CVSAnalY
--------

Git information retrieval. This tool analyzes all of the git repositories available under a local directory and stores such information in a MySQL database.

Bicho
-----

This tool is used for several purposes:
- Launchpad tickets retrieval from https://launchpad.net/openstack
- Gerrit information retrieval from https://review.openstack.org
- StoryBoard stories retrieval from https://storyboard.openstack.org/

Each of these tools stores the correspondant API of each of the mentioned
technologies. That information is later stored in a MySQL database.

Sibyl
-----

Sibyl retrieves information from the Askbot site of OpenStack at 
http://ask.openstack.org/. This is later stored in a MySQL database.

IRCAnalysis
-----------

This is a simple Python based script that parses log information. This is 
retrieved from http://eavesdrop.openstack.org/irclogs/.

Mailing List Stats
------------------

This tool parses mailing lists information in mbox format. This analyzes
all information found at http://lists.openstack.org/cgi-bin/mailman/listinfo.

Unique identities generator
---------------------------

This tool uses heuristics to match same identities accross the several
repositories of information. This tool simply adds or updates information
in the existing databases.

Architecture schema
-------------------

  Git------------> CVSAnalY--------> CVSAnaly database-----|
  Launchpad------> Bicho-----------> Bicho database--------|
  Gerrit---------> Bicho-----------> Bicho database--------|
  StoryBoard-----> Bicho-----------> Bicho database--------|+Unique identities db
  Askbot---------> Sibyl-----------> Sibyl database--------|
  IRC logs-------> IRCAnalysis-----> IRCAnalysis database--|
  Mailing lists--> MLStats---------> MLStats database------|

