#!/usr/bin/perl
#######################################################################
#  A script for fetching the top search result html-file from google. #
#  Arg1 is the search-word, returns a simple xml file encoded and all.#
#######################################################################

use strict;
use warnings;

use Google::Search;
use HTML::Entities;

sub get_perl {

    my $arg1 = shift;
    my $search = Google::Search->Web("q" => "site:perldoc.perl.org $arg1");
    my $result = $search->first;
    my $url = $result->uri . "\n";

    print $search->error->reason, "\n" if $search->error;

    my @splittedurl = split /\//, $url;
    my $filename = pop(@splittedurl);
    my $file;

    my $out = "<?xml version=\"1.0\">\n<sections>";

    `wget -q $url`;

    open $file, $filename or die $!;


    my $section = 0;

    while (<$file>) {

	if (/<a name="[A-Za-z\-]*"><\/a><h2>([A-Za-z\-]*)/){
	    if ($section) {
		$out .= "</content></section>\n";
	    }
	    $section = 1;
	    $out .= "<section>\n";

	}
	if (/<div/) {
	    $section = 0;
	    $out .= "</content></section>";
	}
	if ($section) {
	    if (/<pre class="verbatim">/) {
		#KOD?! nämen va gott! äta taggar, formatera och skriva ut
		s/<pre class="verbatim">/code\n/;
		s/<\/pre>/\n\/code\n/;
		s/<\/li>/\n/g;
		s/<[^>]*>//g;

		#fixa tecken!
		s/&lt;/</g;
		s/&gt;/>/g;
		s/&#39;/'/g;


		#koda tecken
		encode_entities( $_, "<>&");
		s/^code/<code>/g;
		s/\/code/<\/code>/g;
		s/&quot;/"/g;
		$out .= $_;

	    }elsif(/<h2>/){

		# lägga dit överskrifter

		s/<[^>]*>//g;
		s/\n//g;
		$out .= "<title>$_</title>\n<content>"

	    }else {
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

    return $out;

}

1;
