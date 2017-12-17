#!/usr/bin/perl

use Image::Magick;

opendir(DIR,"./");
@pics = grep { /.JPG$/ && -f "$_" } readdir(DIR);
closedir(DIR);

while(<@pics>) {
   $_ =~ s/(.*)\..../$1/;

   $page .= "<a href=\"$_-10.html\"><img src=\"$_-0.jpg\"></a>";
#   $page .= "<a href=\"$_-10.html\">S</a>\n";
#   $page .= "<a href=\"$_-25.html\">M</a>\n";
#   $page .= "<a href=\"$_-50.html\">L</a></div>\n";

   push(@list,$_);
   while(0) { #begin big comment
      print "Processing $_";
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
   } #end big comment
}

open(OUTPUT,">index.html");
print OUTPUT "<html><body>";
print OUTPUT <<EOF;
<style type="text/css">
img {
   margin: 2.5px;
}
</style>
EOF
print OUTPUT $page;
print OUTPUT "</body></html>";
close(OUTPUT);

while($elem = shift(@list)){
   $next = $list[0];
   foreach(10,25,50) {
      open(SUB,">$elem-$_.html");
      print SUB " <html><body><center><br><a href=\"$elem.JPG\"><img src=\"$elem-$_.jpg\"></a><br>";
      print SUB "<a href=\"index.html\">^</a><br>\n";
      if($last) { print SUB "<a href=\"$last-$_.html\">&lt;&lt;</a> " }
      print SUB "<a href=\"$elem-10.html\">S</a>\n";
      print SUB "<a href=\"$elem-25.html\">M</a>\n";
      print SUB "<a href=\"$elem-50.html\">L</a>\n";
      if($next) { print SUB "<a href=\"$next-$_.html\">&gt;&gt;</a>\n" }
      print SUB "</body></html>";
   }
   $last = $elem;
}
