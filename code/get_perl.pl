#!/usr/bin/perl
#######################################################################
#  A class for fetching the top search result html-file from google.  #
#  Uses keywords, returns a simple xml file encoded and all.          #
#######################################################################

# Bug: Last <code> not there when searching for "for loop", dont know why

package GetPerl;

use strict;
use warnings;

use Google::Search;
use HTML::Entities;

sub new {
    my $class = shift;
    my $self = {};

    $self->{KEYWORDS} = [];

    bless($self, $class);
    return $self;
}

# Gets the array of keywords.
sub get_keywords {
    my $self = shift;

    return $self->{KEYWORDS};
}

# Sets the array of keywords to use.
sub set_keywords {
    my $self = shift;
    $self->{KEYWORDS} = shift;
}

#search the web with the new keywords
sub search {
  my $self = shift;
  my $arg1;
    for my $keyword (@{$self->{KEYWORDS}}) {
	$arg1 .= $keyword . " ";
    }
  $self->{SEARCH} = Google::Search->Web("q" => "site:perldoc.perl.org $arg1");
  $self->{RESULT} = $self->{SEARCH}->first;
}

# Gets an XML file of the documentation.
sub get_xml {
    my $self = shift;

    my $url = $self->{RESULT}->uri . "\n";



    my @splittedurl = split /\//, $url;
    my $filename = pop(@splittedurl);
    my $file;
    chomp($filename);

    my $out = "<?xml version=\"1.0\">\n<sections>";

    `wget -q $url`;

    open $file, $filename or die $!;


    my $section = 0;

    while (<$file>) {
	#s/<a name="[^<]*"><\/a>//g;
	#if (/<a name="[A-Za-z\-]*"><\/a><h2>([A-Za-z\-]*)/){
	if (/<a name="[^<]*">[^<]*<\/a><h[1-6]>([^<]*)/s) {
	    if ($section) {
		$out .= "</content></section>\n";
	    }
	    $section = 1;
	    $out .= "<section><title>$1</title>\n<content>\n";

	}
	if (/<div/ && $section == 1) {
	    $section = 0;
	    $out .= "</content></section>";
	    last;
	}
	if ($section) {
	    if (/<pre class="verbatim">/g) {
		#KOD?! nämen va gott! äta taggar, formatera och skriva ut
		s/<pre class="verbatim">/\ncode\n/g;
		s/<\/pre>/\n\/code\n/g;
		s/<\/li>/\n/g;
		s/<[^>]*>//g;

		#fixa tecken!
		s/&lt;/</g;
		s/&gt;/>/g;
		s/&#39;/'/g;
		s/&quot;/"/g;

		#koda tecken
		encode_entities( $_, "<>&");
		s/^code/<code>/mg;
		s/^\/code/<\/code>/mg;

		$out .= $_;
	    }
	    #elsif(/<h2>/) {

		# lägga dit överskrifter

	#	s/<[^>]*>//g;
	#	s/\n//g;
	#	$out .= "<title>$_</title>\n<content>"

	   # }
	    else {
		# äta taggar och skriva vanlig text, formatera fnuttar
		s/<[^>]*>//g;
		s/&quot;/"/g;
		s/&#39;/'/g;
		encode_entities( $_, "<>&");
		$out .= "$_";

	    }

	}
    }

    $out .= "</sections>";

    close $file or die $!;

    `rm $filename`;
    $self->{RESULT} = $self->{SEARCH}->next;

    return $out;

}

1;
