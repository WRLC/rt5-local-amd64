# Single-quote all values EXCEPT the special value `undef`
# that turns off a setting.

# rtname appears in ticket email subjects. It needs to be globally unique,
# so use your organization's domain name.
Set($rtname, 'rt5.wrlc.localhost');
# Organization is used in the database for ticket links, etc. It also needs to
# be globally unique, so use your organization's domain name.
Set($Organization, 'rt5.wrlc.localhost');
# WebDomain is domain name of the RT web server. RT uses it to construct links
# and defend against CSRFs.
Set($WebDomain, 'rt5.wrlc.localhost');
# WebPort is the port where the RT web server runs. Edit the number below if
# you're not using the standard HTTPS port.
Set($WebPort, '80');
# WebPath is the path where the RT web server runs on your WebDomain.
# Edit the path below only if you're using a specific path like example.com/rt
Set($WebPath, '/rt');

# DatabaseUser is the name of the database account RT uses to read and store
# data. 'rt_user' is the default but you can change it if you like.
# DO NOT use the 'rt_admin' superuser created in the instructions above.
Set($DatabaseUser, 'rt5');
# DatabasePassword is the password for DatabaseUser.
Set($DatabasePassword, 'rt5');
# DatabaseHost is the hostname of the database server RT should use.
# Change 'localhost' if it lives on a different server.
Set($DatabaseHost, 'mariadb');
# DatabasePort is the port number of the database server RT should use.
# `undef` means the default for that database. Change it if you're not
# using the standard port.
Set($DatabasePort, undef);
# DatabaseName is the name of RT's database hosted on DatabaseHost.
# 'rt5' is the default but you can change it if you like.
Set($DatabaseName, 'rt5');
# DatabaseAdmin is the name of the user in the database used to perform
# major administrative tasks. Change 'rt_admin' if you're using a user
# besides the one created in this guide.
Set($DatabaseAdmin, 'rt5');

# RT can log to syslog, stderr, and/or a dedicated file.
# Log settings are used both by the primary server and by command line
# tools like rt-crontool, rt-ldapimport, etc.
# You set all of RT's $LogTo* paramaters to a standard log level: 'debug',
# 'info', 'notice', 'warning', 'error', 'critical', 'alert', or 'emergency'.
# For a modern install, if you log to syslog, it goes
# to journald where it's easy to query and automatically gets rotated.
# Some syslogs log only warn and error, so lower levels like debug won't appear here.
Set($LogToSyslog, 'warning');

# When the RT server logs to stderr, that will go to the rt-server journal.
# Command line tools log to their own stderr. Setting this to
# 'warning' or 'error' helps ensure you get notified if RT's cron jobs
# encounter problems.
# When running with Apache, these logs will go to the Apache error log,
# which should be set up with logrotate automatically.
Set($LogToSTDERR, 'warning');

Set($LogToFile,      'debug');
Set($LogToFileNamed, 'rt.log');
Set($LogDir,         '/opt/rt5/var/log');

Set( %FullTextSearch,
    Enable     => 1,
    Indexed    => 1,
    # Additional output from rt-setup-fulltext-index should be here.
    # The configuration varies by database type.
);

Set( $WebRemoteUserAuth, 1 );
Set( $WebRemoteUserAutocreate, 1 );
Set( $WebFallbackToRTLogin, 0 );

# Perl expects to find this 1 at the end of the file.
1;