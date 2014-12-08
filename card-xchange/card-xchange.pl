#! /usr/bin/perl
use warnings;
use strict;
use autodie;

use List::Util qw(shuffle);

my @list;

my $infile  = $ARGV[0];
my $outfile = $ARGV[1];
my $count   = $ARGV[2];

open(my $fh, "<", $infile);
open(my $out, ">", $outfile);

printf("Reading from '%s', writing to '%s', everyone gets %d\n", $infile, $outfile, $count);

while (my $line = <$fh>) {
    chomp($line);
    my @fields = split /\t/, $line;

    push @list, $fields[0];
}

@list = shuffle @list;

if ($count >= @list) { 
    die sprintf("Can't give %d unique items -- only %d in list\n", $count, scalar(@list));
}

my @picked;
for my $round ( 1 .. $count ) {
    $picked[$round-1] = [ @list[$round .. $#list, 0 .. $round-1] ];
}

@list = sort { $a cmp $b } @list;

for my $index (0 .. $#list) {
    print $out join(
        "\t",
        qq{"$list[$index]"},
        map { qq{"$picked[$_-1][$index]"} } 1 .. $count        
    ), "\n";
}
