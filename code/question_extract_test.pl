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
while(<>){
  $qe->set_question($_);
  $qe->extract_information();
  print $qe->get_question();
}


1;
