#!/usr/bin/perl
#######################################################################
#  A script for fetching the top search result html-file from google. #
#  Arg1 is the search-word, returns a simple xml file encoded and all.#
#######################################################################

use strict;
use warnings;

use Google::Search;
use HTML::Entities;


my $arg1 = shift;
my $search = Google::Search->Web(q => "site:$perldoc.perl.org $arg1");
my $result = $search->first;
my $url = $result->uri . "\n";

print $search->error->reason, "\n" if $search->error;

my @splittedurl = split /\//, $url;
my $filename = pop(@splittedurl);
my $file;

`wget $url`;

open $file, $filename or die $!;


my $section = 0;

while (<$file>) {
  
  if(/<a name="[A-Za-z\-]*"><\/a><h2>([A-Za-z\-]*)/){
    if ($section) {
      print "</section>\n";
    }
    $section = 1;
    print "<section>\n";
  
  }
  if (/<div/) {
    $section = 0;
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
      print;
    
    }elsif(/<h2>/){

      # lägga dit överskrifter
     
      s/<[^>]*>//g;
      s/\n//g;
      print "<title>$_</title>\n"

    }else {
      # äta taggar och skriva vanlig text, formatera fnuttar
      s/<[^>]*>//g;
      s/&quot;/"/g;
      s/&#39;/'/g;
      encode_entities( $_, "<>&");
      print"$_";

    }

  }

  
}





close $file or die $!;

`rm $file`

1;
