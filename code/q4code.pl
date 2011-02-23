#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Entities;
require "extract.pl";
require "get_perl.pl";

# Read question from user, command line or args
# Determine type of question, language and keywords

my @keywords = ( "for", "loop" ); # test keywords
# Get data from internet
my $get_perl = GetPerl->new();
$get_perl->set_keywords(\@keywords);
my $data = $get_perl->get_xml();

# Create object for extracting information
my $ext = Extract->new("perl", \@keywords);
# Set data of the extract object, formatted page from internet
$ext->set_data($data);
# Extract text or code depending on question type
my $result = $ext->extract_text();
# Print the title and content
print decode_entities($result->{"title"} . "\n" . $result->{"content"} . "\n");
# The extract class chooses by probability, print it too
print "Probability: " . $ext->get_probability() . "\n";

1;
