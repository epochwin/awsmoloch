# Latest settings documentation: https://github.com/aol/moloch-nightly/wiki/Settings
#
# Moloch uses a tiered system for configuration variables.  This allows Moloch
# to share one config file for many machines.  The ordering of sections in this
# file doesn't matter.
#
# Order of config variables:
# 1st) [optional] The section titled with the node name is used first.
#      Moloch will always tag sessions with node:<node name>
# 2nd) [optional] If a node has a nodeClass variable, the section titled with
#      the nodeClass name is used next.  Sessions will be tagged with
#      node:<node class name> which is useful if watching different
#      network classes.
# 3rd) The section titled "default" is used last.

[default]
# Comma seperated list of elasticsearch host:port combinations.  If not using a
# elasticsearch VIP, a different elasticsearch node in the cluster can be specified
# for each Moloch node to help spread load on high volume clusters
elasticsearch=http://${viewer_private}:9200

# How often to create a new elasticsearch index. hourly,daily,weekly,monthly
# Changing the value will cause previous sessions to be unreachable
rotateIndex=daily

# Cert file to use, comment out to use http instead
# certFile=/data/moloch-nightly/etc/moloch.cert

# File with trusted roots/certs. WARNING! this replaces default roots
# Useful with self signed certs and can be set per node.
# caTrustFile=/data/moloch-nightly/etc/roots.cert

# Private key file to use, comment out to use http instead
# keyFile=/data/moloch-nightly/etc/moloch.key

# S2S and Password Hash secret - Must be in default section. Since elasticsearch
# is wide open by default, we encrypt the stored password hashes with this
# so a malicous person can't insert a working new account.  It is also used
# for secure S2S communication. Comment out for no user authentication.
# Changing the value will make all previously stored passwords no longer work.
passwordSecret = test1234

# HTTP Digest Realm - Must be in default section.  Changing the value
# will make all previously stored passwords no longer work
httpRealm = Moloch

# The base path for Moloch web access.  Must end with a / or bad things will happen
# Default: "/"
# webBasePath = /moloch-nightly/

# Semicolon ';' seperated list of interfaces to listen on for traffic
interface=eth0

# The bpf filter
#bpf=not port 9200

# The yara file name
#yara=

## Start wiseService configuration
# Host to connect to for wiseService
#wiseHost=127.0.0.1

# Number of seconds to cache results before asking wiseService again
#wiseCacheSecs=600

# Max number of items to store in the wise cache that is local to each moloch-capture node
#wiseMaxCache=100000

# Number of connections to wiseService, this is also the number of concurrent wise queries.
#wiseMaxConns=10

# Number of oustanding requests to the wiseService
#wiseMaxRequests=100
## End wiseService configuration

# Uncomment to log access requests to a different log file
accessLogFile = /data/moloch-nightly/logs/access.log

# The directory to save raw pcap files to
pcapDir = /data/moloch-nightly/raw

# The max raw pcap file size in gigabytes, with a max value of 36G.
# The disk should have room for at least 10*maxFileSizeG
maxFileSizeG = 1

# The max time in minutes between rotating pcap files.  Default is 0, which means
# only rotate based on current file size and the maxFileSizeG variable
maxFileTimeM = 1

# TCP timeout value.  Moloch writes a session record after this many seconds
# of inactivity.
tcpTimeout = 600

# Moloch writes a session record after this many seconds, no matter if
# active or inactive
tcpSaveTimeout = 720

# UDP timeout value.  Moloch assumes the UDP session is ended after this
# many seconds of inactivity.
udpTimeout = 30

# Header to use for determining the username to check in the database for instead of
# using http digest.  Use this if apache or something else is doing the auth.
# Set viewHost to localhost or use iptables
# Might need something like this in the httpd.conf
# RewriteRule .* - [E=ENV_RU:%{REMOTE_USER}]
# RequestHeader set MOLOCH_USER %{ENV_RU}e
#userNameHeader=moloch_user

# Should we parse extra smtp traffic info
parseSMTP=true

# Should we parse extra smb traffic info
parseSMB=true

# Should we parse HTTP QS Values
parseQSValue=false

# Semicolon ';' seperated list of SMTP Headers that have ips, need to have the terminating colon ':'
smtpIpHeaders=X-Originating-IP:;X-Barracuda-Apparent-Source-IP:

# Semicolon ';' seperated list of directories to load parsers from
parsersDir=/data/moloch-nightly/parsers

# Semicolon ';' seperated list of directories to load plugins from
pluginsDir=/data/moloch-nightly/plugins

# Semicolon ';' seperated list of plugins to load and the order to load in
# plugins=tagger.so; netflow.so
plugins=writer-s3.so

# Plugins to load as root, usually just readers
#rootPlugins=reader-pfring; reader-daq.so

# Semicolon ';' seperated list of viewer plugins to load and the order to load in
# viewerPlugins=wise.js

# NetFlowPlugin
# Input device id, 0 by default
#netflowSNMPInput=1
# Outout device id, 0 by default
#netflowSNMPOutput=2
# Netflow version 1,5,7 supported, 7 by default
#netflowVersion=1
# Semicolon ';' seperated list of netflow destinations
#netflowDestinations=localhost:9993

# Specify the max number of indices we calculate spidata for.
# ES will blow up if we allow the spiData to search too many indices.
spiDataMaxIndices=3

# Uncomment the following to allow direct uploads.  This is experimental
#uploadCommand=/data/moloch-nightly/bin/moloch-capture --copy -n {NODE} -r {TMPFILE} -c {CONFIG} {TAGS}

# Title Template
# _cluster_ = ES cluster name
# _userId_  = logged in User Id
# _userName_ = logged in User Name
# _page_ = internal page name
# _expression_ = current search expression if set, otherwise blank
# _-expression_ = " - " + current search expression if set, otherwise blank, prior spaces removed
# _view_ = current view if set, otherwise blank
# _-view_ = " - " + current view if set, otherwise blank, prior spaces removed
#titleTemplate=_cluster_ - _page_ _-view_ _-expression_

# Number of threads processing packets
packetThreads=3

# ADVANCED - Semicolon ';' seperated list of files to load for config.  Files are loaded
# in order and can replace values set in this file or previous files.
#includes=

# ADVANCED - How is pcap written to disk
#  simple        = use O_DIRECT if available, writes in pcapWriteSize chunks,
#                  a file per packet thread.
#pcapWriteMethod=simple
pcapWriteMethod=s3

# ADVANCED - Buffer size when writing pcap files.  Should be a multiple of the raid 5 or xfs
# stripe size.  Defaults to 256k
pcapWriteSize = 128000

# ADVANCED - value for pcap_set_buffer_size, may not be used depending on kernel etc
pcapBufferSize = 30000000

# ADVANCED - Number of bytes to bulk index at a time
dbBulkSize = 300000

# ADVANCED - Number of seconds before we force a flush to ES
dbFlushTimeout = 5

# ADVANCED - Compress requests to ES, reduces ES bandwidth by ~80% at the cost
# of increased CPU. MUST have "http.compression: true" in elasticsearch.yml file
compressES = false

# ADVANCED - Max number of connections to elastic search
maxESConns = 30

# ADVANCED - Max number of es requests outstanding in q
maxESRequests = 500

# ADVANCED - Number of packets to ask libnids/libpcap to read per poll/spin
# Increasing may hurt stats and ES performance
# Decreasing may cause more dropped packets
packetsPerPoll = 50000

# ADVANCED - Moloch will try to compensate for SYN packet drops by swapping
# the source and destination addresses when a SYN-acK packet was captured first.
# Probably useful to set it false, when running Moloch in wild due to SYN floods.
antiSynDrop = true

# DEBUG - Write to stdout info every X packets.
# Set to -1 to never log status
logEveryXPackets = 100000

# DEBUG - Write to stdout unknown protocols
logUnknownProtocols = false

# DEBUG - Write to stdout elastic search requests
logESRequests = true

# DEBUG - Write to stdout file creation information
logFileCreation = true

s3Region=${aws_region}
s3Bucket=${s3_bucket}
s3AccessKeyId=${moloch_access_id}
s3SecretAccessKey=${moloch_secret_key}

##############################################################################
# Classes of nodes
# Can override most default values, and create a tag call node:<classname>
[class1]
freeSpaceG = 10%

##############################################################################
# Nodes
# Usually just use the hostname before the first dot as the node name
# Can override most default values

#[node1]
#nodeClass = class1
# Might use a different elasticsearch node
#elasticsearch=elasticsearchhost1

# Uncomment if this node should process the cron queries, only ONE node should process cron queries
# cronQueries = true

#[node2]
#nodeClass = class2
# Might use a different elasticsearch node
#elasticsearch=elasticsearchhost2
# Uses a different interface
#interface = eth4

##############################################################################
# override-ips is a special section that overrides the MaxMind databases for
# the fields set, but fields not set will still use MaxMind (example if you set
# tags but not country it will use MaxMind for the country)
# Spaces and capitalization is very important.
# IP Can be a single IP or a CIDR
# Up to 10 tags can be added
#
# ip=tag:TAGNAME1;tag:TAGNAME2;country:3LetterUpperCaseCountry;asn:ASN STRING
#[override-ips]
#10.1.0.0/16=tag:ny-office;country:USA;asn:AS0000 This is an ASN

##############################################################################
# It is now possible to define in the config file extra http/email headers
# to index.  They are accessed using the expression http.<fieldname> and
# email.<fieldname> with optional .cnt expressions
#
# Possible config atributes for all headers
#   type:<string> (string|integer|ip)  = data type                (default string)
#  count:<boolean>                     = index count of items     (default false)
#  unique:<boolean>                    = only record unique items (default true)

# headers-http-request is used to configure request headers to index
#[headers-http-request]
#referer=type:string;count:true;unique:true

# headers-http-response is used to configure http response headers to index
#[headers-http-response]
#location=type:string;count:true

# headers-email is used to configure email headers to index
#[headers-email]
#x-priority=type:integer

##############################################################################
# If you have multiple clusters and you want the ability to send sessions
# from one cluster to another either manually or with the cron feature fill out
# this section

#[moloch-clusters]
#forensics=url:https://viewer1.host.domain:8005;passwordSecret:password4moloch;name:Forensics Cluster
#shortname2=url:http://viewer2.host.domain:8123;passwordSecret:password4moloch;name:Testing Cluster
