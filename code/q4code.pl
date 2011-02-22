#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Entities;
require "extract.pl";

my @keywords = ( "for", "loop" );
my $ext = Extract->new("perl", \@keywords);

open(DUMMY, "extract-data.xml") || die("Could not open extract-data.xml\n");
my $data = "";
while (<DUMMY>) {
    $data .= $_;
}
close(DUMMY);
$ext->set_data($data);
print decode_entities($ext->extract_code());
print "Probability: " . $ext->get_probability() . "\n";

1;
