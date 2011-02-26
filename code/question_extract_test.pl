#!/usr/bin/env perl

###############################################################################
# question_extract_test.pl
# This file is only used to test Question_extract, found in 
# question_extract.pl.
#
###############################################################################

use strict;
use warnings;

require "question_extract.pl";

my $qe = Question_extract->new();
$qe->set_question("How to read from a file?");
$qe->extract_information();
my @keywords = $qe->get_keywords();
for (@keywords) { print $_, "\n"; }

1;