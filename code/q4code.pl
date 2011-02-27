#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Entities;
require "extract.pl";
require "get_perl.pl";
require "question_extract.pl";

# Usage: ./q4code "What does a for loop look like in perl?"

# Read question from user, command line or args
# Determine type of question, language and keywords
my $qe = Question_extract->new();
$qe->set_question($ARGV[0]);
$qe->extract_information();
my @keywords = $qe->get_keywords();
my $language = $qe->extract_language();
# Get data from internet
my $get;

if ($language eq "perl") {
    $get = GetPerl->new();
}
else {
    die "No such language\n";
}
$get->set_keywords(\@keywords);
my $data = $get->get_xml();

# Create object for extracting information
my $ext = Extract->new($language, \@keywords);
# Set data of the extract object, formatted page from internet
$ext->set_data($data);
# Extract text or code depending on question type
my $result = $ext->extract_text();
# Print the title and content
print decode_entities($result->{"title"} . "\n" . $result->{"content"} . "\n");
# The extract class chooses by probability, print it too
print "Probability: " . $ext->get_probability() . "\n";

1;
