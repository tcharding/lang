#!/usr/bin/perl

use RRDs;

my $rrdlog = '/var/www/rrd';
my $graphs = '/var/www/rrd';
my $disk = 'md2';

updatedata ();
updategraph ('day');
updategraph ('week');
updategraph ('month');
updategraph ('year');

sub updatedata {
        my ($readsect, $writesect);

        if ( ! -e "$rrdlog/disk.rrd") {
                RRDs::create ("$rrdlog/disk.rrd", "--step=300",
                        "DS:readsect:COUNTER:600:0:5000000000",
                        "DS:writesect:COUNTER:600:0:5000000000",
                        "RRA:AVERAGE:0.5:1:576",
                        "RRA:AVERAGE:0.5:6:672",
                        "RRA:AVERAGE:0.5:24:732",
                        "RRA:AVERAGE:0.5:144:1460");
                $ERROR = RRDs::error;
                print "Error in RRD::create for disk: $ERROR\n" if $ERROR;
                print "$rrdlog/disk.rrd created.";
        }

        my @diskdata = `iostat -d $disk`;
        my $temp = $diskdata[3];
        chomp($temp);

        my @tempa = split(/\s+/, $temp);

        $readsect= $tempa[4];
        $writesect= $tempa[5];

#        print "N:$readsect:$writesect\n";

        RRDs::update ("$rrdlog/disk.rrd",
                "-t", "readsect:writesect",
                "N:$readsect:$writesect");

        $ERROR = RRDs::error;
        print "Error in RRD::update for disk: $ERROR\n" if $ERROR;
}

sub updategraph {
        my $period    = $_[0];

        RRDs::graph ("$graphs/disk-$period.png",
                "--start", "-1$period", "-aPNG", "-i", "-z",
                "--alt-y-grid", "-w 700", "-h 150", "-l 0", "-r",
                "-t disk access per $period",
                "-v sectors/sec",
                "DEF:read=$rrdlog/disk.rrd:readsect:AVERAGE",
                "DEF:write=$rrdlog/disk.rrd:writesect:AVERAGE",
                "AREA:read#0000FF:sectors read from disk per second\\j",
                "STACK:write#00FF00:sectors written to disk per second\\j",
                "GPRINT:read:MAX:maximal read sectors\\:%8.0lf",
                "GPRINT:read:AVERAGE:average read sectors\\:%8.0lf",
                "GPRINT:read:LAST:current read sectors\\:%8.0lf\\j",
                "GPRINT:write:MAX:maximal written sectors\\:%8.0lf",
                "GPRINT:write:AVERAGE:average written sectors\\:%8.0lf",
                "GPRINT:write:LAST:current written sectors\\:%8.0lf\\j");
        $ERROR = RRDs::error;
        print "Error in RRD::graph for disk: $ERROR\n" if $ERROR;
}