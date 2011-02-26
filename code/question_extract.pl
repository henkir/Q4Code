#!/usr/bin/env perl
use strict;
use warnings;

my @questions = ("What does a for-loop look like in Perl?",
				 "What is the syntax of Python?",
				 "How does input/ouput work in Perl?",
				 "What is a for?",
				 "What a for loop!");


sub extract_specified_language {
	my $question = shift;
	my $specified_language = "ALL";

	if (lc($question) =~ /(perl|python)/) {
		$specified_language = $1;
	}
	
	return $specified_language;
}

print "--- PRINTING EXTRACTED LANGUAGES ---\n";
for (@questions) {
	print extract_specified_language($_), "\n";
}

sub find_keywords {
	my $question = shift;
	my $re = shift;
	
	my @keywords = ();
	my $match = "";
	do {
		if ($question =~ /($re)(.*)/) {
			$match = $1;
			push(@keywords, $match);
			$question = $2;
		} else {
			$match = ""
		}
	} while ($match);	
	
	return @keywords;
}

print "\n--- PRINTING EXTRACTED KEYWORDS ---\n";
for (@questions) {
	print "Question: ", $_, "\n";
	my @keywords = find_keywords($_, "for[- ]loops?|a for ");
	
	if (@keywords) {
		#look for example or desc?
	}
	
	print "\n";
}


1;