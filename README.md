About lastools
--------------

‘lastools’ is an R package for reading and writing [version
1.2](http://www.cwls.org/wp-content/uploads/2014/09/LAS12_Standards.txt)
and [version
2.0](http://www.cwls.org/wp-content/uploads/2017/02/Las2_Update_Feb2017.pdf)
Log ASCII Standard (LAS) files (Canadian Well Logging Society (1990),
Canadian Well Logging Society (2017d)) and for performing common
functions on LAS files including:

-   version conversion

-   depth conversion

-   merging

-   visualizing/plotting

-   re-sampling/filtering

-   bulk loading to R data.table

While the Canadian Well Logging Society provides free software called
[LasApps](http://www.cwls.org/wp-content/uploads/2017/02/CWLS_LasApps_v2_4_14.msi)
(Canadian Well Logging Society (2017c)) and a Python package called
[lasio](http://pythonhosted.org/lasio/index.html) (Inverarity (2017))
exists to perform similar functions; at time of writing no R package
existed for reading and manipulating LAS files.

The aim of lastools is to provide functionality for reading and
manipulating LAS files in the R environment and to provide additional
unique functionality not found in existing alternative
packages/libraries/software.

Installation
------------

lastools can be installed from github repository using devtools:

devtools::install\_github(“Gitmaxwell/lastools”)

LAS Data
--------

### Las file

A LAS file is a standardized, structured ASCII file containing header
information and log curve data derived from the continuous collection of
(usually geophysical) measurements from a borehole or well (Firth
(n.d.)). They are often termed wireline log LAS files and have the file
extension “.las”. They are *distinct* from ‘lidar’ LAS files which are
’industry-standard binary format files for storing [airborne lidar
data](http://desktop.arcgis.com/en/arcmap/10.3/manage-data/las-dataset/what-is-a-las-dataset-.htm).

The LAS standard was introduced by the Canadian Well Logging Society in
1989 and to date consists of 3 Versions (version 1.2 (1989), 2.0 (1992)
& 3.0 (1999)) (Canadian Well Logging Society (2017a)). Version 2.0
replaced inconsistencies in version 1.2 while version 3.0 clarified some
of the poorly defined specifications of LAS 2.0 and provides expanded
data storage capabilities (Canadian Well Logging Society (1990),
Canadian Well Logging Society (2017d), Canadian Well Logging Society
(2017b)). Despite version 3.0 being the ‘latest’ version, its
implementation and usage has been extremely limited (Canadian Well
Logging Society (2017a)). Following this, the package lastools only
provides support for LAS file versions 1.2 & 2.0.

The exact standards and structure/s for each LAS file type can be
accessed via the below links (and/or from the embedded hyperlinks
elsewhere):

[Las Standard
1.2](http://www.cwls.org/wp-content/uploads/2014/09/LAS12_Standards.txt)

[Las Standard
2.0](http://www.cwls.org/wp-content/uploads/2017/02/Las2_Update_Feb2017.pdf)

[Las Standard
3.0](http://www.cwls.org/wp-content/uploads/2014/09/LAS_3_File_Structure.pdf)

References
----------

Canadian Well Logging Society. 1990. “LAS 1.2 a Floppy Disk Standard for
Log Data.” Connecticut, USA: Canadian Well Logging Society. 1990.
<http://www.cwls.org/wp-content/uploads/2014/09/LAS12_Standards.txt>.

———. 2017a. “HELP: Load - Log Ascii Standard (Las) File, Versions 2.0 &
3.0.” Connecticut, USA: Canadian Well Logging Society. 2017.
<http://www.kgs.ku.edu/software/SS/HELP/las/index.html>.

———. 2017b. “Las 3.0 Log Ascii Standard.” Connecticut, USA: Canadian
Well Logging Society. 2017.
<http://www.cwls.org/wp-content/uploads/2014/09/LAS_3_File_Structure.pdf>.

———. 2017c. “LAS (Log Ascii Standard).” Connecticut, USA: Canadian Well
Logging Society. 2017. <http://www.cwls.org/las/>.

———. 2017d. “LAS Version 2.0: A Digital Standard for Logs.”
<http://www.cwls.org/wp-content/uploads/2017/02/Las2_Update_Feb2017.pdf>.

Firth, David. n.d. “Log Analysis for Mining Applications.”

Inverarity, Kent. 2017. “Lasio - Log Ascii Standard (Las) Files in
Python.” Kent Inverarity. 2017. <http://pythonhosted.org/lasio/>.
