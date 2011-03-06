#!/usr/bin/env perl

###############################################################################
# question_extract.pl
# Provides a class Question_extract for extracting information from a provided 
# question. Strips provided question down to keywords and extracts language.
###############################################################################

package Question_extract;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self  = {};
	#$self->{EXAMPLE}		= undef;
	#$self->{DESCRIPTION}	= undef;
	$self->{LANGUAGE}		= undef;
	$self->{QUESTION}		= undef;
	bless($self, $class);
	return $self;
}

#sub get_example {
#	my $self = shift;
#	return $self->{EXAMPLE};
#}

#sub get_description {
#	my $self = shift;
#	return $self->{DESCRIPTION};
#}

sub get_language {
	my $self = shift;
	return $self->{LANGUAGE};
}

sub get_question {
	my $self = shift;
	return $self->{QUESTION};	
}

sub set_question {
	my $self = shift;
	
	$self->{QUESTION} = lc(shift);
	$self->{QUESTION} =~ s/[,?\.!]//g;
	$self->{QUESTION} =~ s/-/ /g;
}

sub extract_information {
	my $self = shift;
	
	$self->extract_language();
	$self->strip_to_keywords();
}

sub extract_language {
	my $self = shift;
	$self->{LANGUAGE} = "NONE";
	
	if ($self->{QUESTION} =~ s/((in )?(perl\'?s?)) ?//) {
		$self->{LANGUAGE} = $3;
	} else{
	  $self->{LANGUAGE} = "perl";
	}
}

sub strip_to_keywords {
	my $self = shift;
	my $question = $self->{QUESTION};
	
	my @removal = ( # not final
		"(does |do |to )(a |you )?(use )?",
		"look ?(like ?)?",
		"statements? ?",
		"what ?",
		"how ?",
		"the ?",
	);

	for my $to_remove (@removal) {
		$question =~ s/[^a-zA-Z]?$to_remove[^a-zA-Z]?//g;
	}

	$self->{QUESTION} = $question;	
}

1;
