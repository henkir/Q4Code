#!/usr/bin/env perl

###############################################################################
# get_perl_test.pl
# This file is only used to test GetPerl, in extract.pl
#
###############################################################################

use strict;
use warnings;
use HTML::Entities;
require "get_perl.pl";

my @keywords = ( "for", "loop" ); # test keywords
# Get data from internet
my $get_perl = GetPerl->new();
$get_perl->set_keywords(\@keywords);
my $data = $get_perl->get_xml();
open(FILE, ">perl_test.xml") or die $!;
print FILE $data;
close(FILE) or die $!;

1;
