#!/usr/bin/env perl

################################################################################
# extract.pl
# Provides a class for specifying programming language, keywords and data.
# Then by using the extract_text or extract_data methods, the most probable
# text or data is extracted and returned.
################################################################################

package Extract;

# Want to get warnings to prevent sloppy coding.
use strict;
use warnings;

# Creates a new instance of the class.
# language (optional) programming language to extract
# keywords (optional) array with keywords to search for
sub new {
    my $class = shift;
    my $self = {};
    $self->{LANGUAGE} = shift;
    $self->{KEYWORDS} = shift;
    $self->{DATA} = undef;
    $self->{PROBABILITY} = undef;
    bless($self, $class);
    return $self;
}

# Gets the language the object is set to extract.
sub get_language {
    my $self = shift;
    return $self->{LANGUAGE};
}

# Gets the keywords the object is set to search for.
sub get_keywords {
    my $self = shift;
    return $self->{KEYWORDS};
}

# Gets the probability for the latest extraction.
sub get_probability {
    my $self = shift;
    return $self->{PROBABILITY};
}

# Sets the language to extract.
# language string with language
sub set_language {
    my $self = shift;
    $self->{LANGUAGE} = shift;
}

# Sets the keywords to search for
# keywords array of keywords
sub set_keywords {
    my $self = shift;
    $self->{KEYWORDS} = shift;
}

# Sets the data to search in
# data string with data
sub set_data {
    my $self = shift;
    $self->{DATA} = shift;
}

# Extracts code by using extract_text and then fetching only the code parts.
sub extract_code {
    my $self = shift;
    # Get the extracted text
    my $text = $self->extract_text();
    my $code = "";
    my $content = $text->{"content"};
    # Get all code blocks
    while ($content =~ /(<code>[^<>]*<\/code>)/sg) {
	$code .= $1 . "\n";
    }

    $text->{"content"} = $code;

    return $text;
}

# Extracts text from data by using keywords, returns the most probable match.
sub extract_text {
    my $self = shift;
    my @alternatives = ();
    my $i = 0;
    my $p;

    # Get all sections
    while ($self->{DATA} =~ /<section>\s*(.*?)\s*<\/section>/sg) {
	my $section = $1;
	# Get title and content of a sections
	if ($section =~ /<title>\s*(.*)\s*<\/title>.*<content>\s*(.*)\s*<\/content>/sg) {
	    my $title = $1;
	    my $content = $2;
	    # Create a hash with the data
	    my %data = ( "title" => $title, "content" => $content);
	    # Add it to the array
	    $alternatives[$i] = \%data;
	    $i += 1;
	}
    }
    $i = 0;

    my @probabilities = ();
    my $max = 0.0;
    my $maxindex = 0;
    my @keywords = $self->{KEYWORDS};
    # Calculate probabilities based on occurrence of keywords
    for my $obj (@alternatives) {
	$probabilities[$i] = 1.0;
	for (my $j = 0; $j < @keywords; $j += 1) {
	    if ($obj->{"title"} =~ /[>\s]+{$self->{KEYWORDS}[$j]}[<\s]+/isg) {
		$probabilities[$i] *= 1;
	    } elsif ($obj->{"title"} =~ /$self->{KEYWORDS}[$j]/isg) {
		$probabilities[$i] *= 0.8;
	    } else {
		$probabilities[$i] *= 0.6;
	    }
	    if ($obj->{"content"} =~ /[>\s]+{$self->{KEYWORDS}[$j]}[<\s]+/isg) {
		$probabilities[$i] *= 1;
	    } elsif ($obj->{"content"} =~ /$self->{KEYWORDS}[$j]/isg) {
		$probabilities[$i] *= 0.8;
	    } else {
		$probabilities[$i] *= 0.6;
	    }
	}
	if ($probabilities[$i] > $max) {
	    $max = $probabilities[$i];
	    $maxindex = $i;
	}
	$i += 1;
    }

    $self->{PROBABILITY} = $max;

    # Return most probable keyword
    return $alternatives[$maxindex];
}

# Returns the current language and keywords of the object.
sub dump {
    my $self = shift;
    my $ret = "Extract with data:\n"
	. "Language = " . $self->{LANGUAGE} . "\n"
	. "Keywords = ";
    my $first = 1;
    foreach my $keyword (@{$self->{KEYWORDS}}) {
	if (!$first) {
	    $ret .= ", ";
	}
	$first = 0;
	$ret .= $keyword;
    }
    $ret .= "\n";

    return $ret;
}

1;
