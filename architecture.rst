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
 * :file:`manifests/init.pp`
 * :file:`manifests/cvsanaly.pp`
 * :file:`manifests/mlstats.pp`
 * :file:`manifests/sibyl.pp`
 * :file:`manifests/bicho.pp`
 * :file:`manifests/ircanalysis.pp`
:Projects:
 * https://github.com/MetricsGrimoire

Overview
========

The site https://activity.openstack.org/dash is based on the information retrieved
by Metrics Grimoire toolset. 

Retrieval Process Architecture
==============================

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


Data Analysis Architecture
==========================

The information process is done through the GrimoireLib library available at
https://github.com/VizGrimoire/GrimoireLib. This library is a database
transparency layer that helps to access the several databases schemas and
generate JSON files.

Given that GrimoireLib is a library, there's a need for a proper tool to use that library.
Report tool is the tool in charge of this analysis, and through the GrimoireLib API, 
generate JSON files.


Architecture schema
-------------------

CVSAnalY database (Git)-----------|                      |
Bicho database (Launchpad)--------|                      |
Bicho database (Gerrit)-----------|                      |
Bicho database (StoryBoard)-------|-Unique identities db-|-GrimoireLib--> JSON files
Sibyl database (Askbot)-----------|                      | 
IRCAnalysis database--------------|                      |
MLStats database (Mailing lists)--|                      |



Visualization
=============

The final step for the whole process is based on the visualization of the JSON files.
In order to avoid dependencies from third party technologies, this approach is focused
on generating static JSON files that feeds the JavaScript machinery of Grimoire toolset.
However, other technologies can be used. 

Visualization consists of two more projects: VizgrimoireJS and VizgrimoireJS-lib.
The latter is the JavaScript library in charge of accessing all of the JSON files and
retrieve the needed information. VizgrimoireJS is a set of HTML/CSS templates (bootstrap based)
that take advantage of such library and visualizes the current version of the dashboard.

Thus, the visualization side only needs of an Apache that serves HTML/CSS/JS/JSON files.


Architecture schema
-------------------

Data Sources -> Retrieval Process -> MySQL ddbb -> Data Analysis -> JSON files -> Visualization

