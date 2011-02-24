#!/usr/bin/env perl
use strict;
use warnings;

my @questions = ("What does a for-loop look like in Perl?",
				 "What is the syntax of Python?",
				 "How does input/ouput work in Perl?");


sub extract_specified_language {
	my $str = shift;
	my $specified_language = "ALL";
	
	if ($str =~ /([pP]erl|[pP]ython)/) {
		$specified_language = $1;
	}
	
	return $specified_language;
}

for (my $i = 0; $i < @questions; $i = $i + 1) {
	my $language = extract_specified_language($questions[$i]);
	print $language . "\n";
}

print "\n";

my @matches = ();
my $match = "";
my $next_str = "input is great for moar input/output";
do {
	print "looping\n";
	print "next_str: " . $next_str . "\n";
	if ($next_str =~ /(input|output)(.*)/) {
		$match = $1;
		push(@matches, $match);
		$next_str = $2;
	} else {
		$match = ""
	}
} while ($match);

print "\n--- PRINTING MATCHES ---\n";
for (my $i = 0; $i < @matches; $i = $i +1) {
	print $matches[$i] . "\n";
}


