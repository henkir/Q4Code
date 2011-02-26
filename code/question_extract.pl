#!/usr/bin/env perl

###############################################################################
# question_extract.pl
# Provides a class Question_extract for extracting information from a provided 
# question. Extracts keywords and programming language as of now.
#
###############################################################################

package Question_extract;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self  = {};
	$self->{EXAMPLE}		= undef;
	$self->{DESCRIPTION}	= undef;
	$self->{LANGUAGE}		= undef;
	$self->{KEYWORDS}		= ();
	$self->{QUESTION}		= undef;
	bless($self, $class);
	return $self;
}

sub get_example {
	my $self = shift;
	return $self->{EXAMPLE};
}

sub get_description {
	my $self = shift;
	return $self->{DESCRIPTION};
}

sub get_language {
	my $self = shift;
	return $self->{LANGUAGE};
}

sub get_keywords {
	my $self = shift;
	return @{ $self->{KEYWORDS} };
}

sub get_question {
	my $self = shift;
	return $self->{QUESTION};	
}

sub set_question {
	my $self = shift;
	$self->{QUESTION} = shift;
}

sub extract_information {
	my $self = shift;
	
	$self->extract_language();
	$self->extract_keywords();
}

sub extract_language {
	my $self = shift;
	$self->{LANGUAGE} = "NONE";
	if ($self->{QUESTION} =~ /(perl|python)/) {
		$self->{LANGUAGE} = $1;
	}
}

sub extract_keywords {
	my $self = shift;
	my $question = $self->{QUESTION};
	
	# FOR LOOPS
	if ($question =~ /for[- ]loops?|a for /) {
		push( @{ $self->{KEYWORDS} }, "for", "loop");
	}
	
	# WHILE LOOPS
	if ($question =~ /a? ?while[- ]loops?/) {
			push( @{ $self->{KEYWORDS} }, "while", "loop");
	}
	
	# FILE INPUT
	if ($question =~ /((read|input) from a? ?file|file input)/) {
		push( @{ $self->{KEYWORDS} }, "read from", "file");
	} else {
		# INPUT
		if ($question =~ /(input)/) {
			push( @{ $self->{KEYWORDS} }, "input");
		}
	}
	
	# FILE OUTPUT
	if ($question =~/((write|output) to a? ?file|file output)/) {
		push( @{ $self->{KEYWORDS} }, "write to", "file");
	} else {
		# OUTPUT
		if ($question =~ /(output|print)/) {
			push( @{ $self->{KEYWORDS} }, "output");
		}
	}
}

1;