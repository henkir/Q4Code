#!/usr/bin/env perl

###############################################################################
# question_extract.pl
# Provides a class Question_extract for extracting information from a provided 
# question. Extracts whether example or description is sought after and in 
# which programming language. Strips provided question down to keywords.
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
	
	$self->{QUESTION} = lc(shift);
	$self->{QUESTION} =~ s/[,?\.!]//g;
	$self->{QUESTION} =~ s/-/ /g;
}

sub extract_information {
	my $self = shift;
	
	$self->extract_language();
	$self->extract_if_example_or_desc();
}

sub extract_language {
	my $self = shift;
	$self->{LANGUAGE} = "NONE";
	if ($self->{QUESTION} =~ s/((in )?(perl))//) {
		$self->{LANGUAGE} = $3;
	}else{
	  $self->{LANGUAGE} = "perl";
	}
}

sub extract_if_example_or_desc {
	my $self = shift;
	my $question = $self->{QUESTION};
	
	if ($question =~ s/(what )//) {
		$self->{EXAMPLE} = 1;
		$self->{DESCRIPTION} = 0;
	} elsif ($question =~ s/(how )//) {
		$self->{EXAMPLE} = 0;
		$self->{DESCRIPTION} = 1;
	} else { # default: description
		$self->{EXAMPLE} = 0;
		$self->{DESCRIPTION} = 1;
	}

	$question =~ s/(does |do |to )(a |you )?(use )?//g;
	$question =~ s/look( like)?//g;
	$question =~ s/statement[s]? ?//g;

	$self->{QUESTION} = $question;	
}

1;
