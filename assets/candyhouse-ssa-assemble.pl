#!/usr/bin/perl -w

use strict;

my $version = '0.0.2';

my $eraseBlockSize = 1024*128;

chomp(my $date = `date +%Y%m%d%H%M%S`);
my $tag = 'wolfteck';

my $jffs2 = glob("*.jffs2");
print "Using JFFS2: $jffs2\n";
my $kernel;

unless($kernel = glob("../build/publication/src/linux/extracted/*/arch/arm/boot/uImage")) {
   ($kernel = $jffs2) =~ s/^(.*)\.(.*?)$/$1.kernel/;
}
print "Using kernel: $kernel\n";

(my $k = $jffs2) =~ s/^(.*)\.(.*?)$/$1.kernel/;
print "Copying $kernel to ./$k ...\n";
system("cp $kernel $k");

my $size = -s $k;
print "$k is $size bytes ...\n";
my $nextBlock = (int($size/$eraseBlockSize)+1)*$eraseBlockSize;
print "Next boundry at $nextBlock bytes ...\n";

my $pad = $nextBlock-$size;
print "Padding $k by $pad bytes ...\n";

open(KERNEL, ">>$k");
binmode(KERNEL);
print KERNEL 0 x $pad;
close(KERNEL);

print "Adding build date ($date) to $jffs2/etc/builddate ...\n";
system("echo '$date' | sudo tee $jffs2/etc/builddate > /dev/null");
print "Adding build tag ($tag-$date) to $jffs2/etc/version ...\n";
system("echo '$tag-$date' | sudo tee  $jffs2/etc/version > /dev/null");

print "Squashing JFFS2 filesystem to $jffs2.tmp ...\n";
system("sudo mkfs.jffs2 -r $jffs2 -o $jffs2.tmp -e 128 -l -n --squash");

(my $image = $jffs2) =~ s/^(.*)\.(.*?)$/$1.ssa/;
$image =~ s/^(.*)\.(.*?)$/$1-$tag-$date.ssa/;
print "Concatinating $k and $jffs2.tmp to $image ...\n";
system("cat $k $jffs2.tmp > $image");

print "Removing $jffs2.tmp ...\n";
system("sudo rm $jffs2.tmp");
