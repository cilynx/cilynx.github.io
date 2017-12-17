#!/usr/bin/perl

use Image::Magick;

opendir(DIR,"./");
@pics = grep { /.JPG$/ && -f "$_" } readdir(DIR);
closedir(DIR);

while(<@pics>) {
   $_ =~ s/(.*)\..../$1/;
   print "Processing $_";

   $page .= "<table><tr><td><a href=\"$_.JPG\"><img src=\"$_-0.jpg\"></a></td></tr><tr><td align=center>";
   $page .= "<a href=\"$_-10.html\">S</a>\n";
   $page .= "<a href=\"$_-25.html\">M</a>\n";
   $page .= "<a href=\"$_-50.html\">L</a></td></tr></table>\n";

   push(@list,$_);

   # Read in the image
   $model = Image::Magick->new();
   $x = $model->ReadImage("$_.JPG");
   warn "$x" if "$x";

   foreach $y (10,25,50) {
      # Scale the image
      $example = $model->Clone();
      $example->Label('Scale');
      $example->Scale("$y%");

      # Write out the image
      $example->Write("$_-$y.jpg");
      if($y eq "50") { print ".\n" } else { print "." }
   }

   $example = $model->Clone();
   $example->Label('Scale');
   $example->Scale('120');
   $example->Write("$_-0.jpg");
}

open(OUTPUT,">index.html");
print OUTPUT "<html><body><center>";
print OUTPUT $page;
print OUTPUT "</body></html>";
close(OUTPUT);

while($elem = shift(@list)){
   $next = $list[0];
   foreach(10,25,50) {
      open(SUB,">$elem-$_.html");
      print SUB " <html><body><center><img src=\"$elem-$_.jpg\"><br>";
      if($last) { print SUB "<a href=\"$last-$_.html\">&lt;&lt;</a>" }
      if($next) { print SUB "<a href=\"$next-$_.html\">&gt;&gt;</a>" }
      print SUB "</body></html>";
   }
   $last = $elem;
}
