#!/usr/bin/perl

###############################################################################
# extract_test.pl
# This file is only used to test Extract, in extract.pl
#
###############################################################################

use strict;
use warnings;
use HTML::Entities;
require "extract.pl";

my @keywords = ( "if", "statement" ); # test keywords

my $data = "";
open(FILE, "extract_test.xml") or die $!;
while (<FILE>) {
    $data .= $_;
}
close(FILE) or die $!;

# Create object for extracting information
my $ext = Extract->new("perl", \@keywords);
# Set data of the extract object, formatted page from internet
$ext->set_data($data);
# Extract text or code depending on question type
my $result;
if ($#ARGV > 0 && $ARGV[0] eq "code") {
    $result = $ext->extract_code();
}
else {
    $result = $ext->extract_text();
}
# Print the title and content
print decode_entities($result->{"title"} . "\n" . $result->{"content"} . "\n");
# The extract class chooses by probability, print it too
print "Probability: " . $ext->get_probability() . "\n";

1;
