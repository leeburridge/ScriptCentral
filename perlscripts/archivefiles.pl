# archivefiles.pl
# Run as a scheduled task that checks $CleanUpDir for files that match @Files pattern

use strict;
use File::Copy;

# Cleanup Dir
my $CleanUpDir = "C:\\";
my $ArchiveDir = "C:\\archive";

# Move files older than 1 day to $ArchiveDir
chdir($CleanUpDir);
my @Files = <file*log>;

foreach (@Files)
{
	if ( -M $_ > 1 )
	{
		print "Moving $_ ... \n";
		move($_,  $ArchiveDir);
	}
}

# Delete archived files older than 7 days
chdir($ArchiveDir);
my @Files = <file*log>;

foreach (@Files)
{
	if ( -M $_ > 7 )
	{
		print "Deleting $_ ... \n";
		unlink($_);
	}
}
