#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Entities;
require "extract.pl";
require "get_perl.pl";

my @keywords = ( "for", "loop" );
my $ext = Extract->new("perl", \@keywords);



#open(DUMMY, "extract-data.xml") || die("Could not open extract-data.xml\n");
my $data = get_perl("for loop");
#while (<DUMMY>) {
#    $data .= $_;
#}
#close(DUMMY);

$ext->set_data($data);
my $result = $ext->extract_text();
print decode_entities($result->{"title"} . "\n" . $result->{"content"} . "\n");
print "Probability: " . $ext->get_probability() . "\n";

1;
