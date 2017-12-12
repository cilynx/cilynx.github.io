#!/usr/bin/perl -w

use strict;

my $version = '0.0.1';

my($offset, $buffer);

# Grab the image name from the command line options

my $image = shift;

# We need to know the image size to calculate the JFFS2 size

my $size = -s $image;
print "Image $image is $size bytes ...\n";

# Use binwalk to find the JFFS2 offset

use Binwalk;
my $binwalk = Binwalk->new($image);
foreach my $part (@{$binwalk->parts()}) { if($part->{desc} =~ /JFFS2/) { $offset = $part->{dec} } }
print "JFFS2 offset is $offset ...\n";

# Open up the raw firmware image

print "Reading $image ...\n";
open(IMAGE, $image) and binmode IMAGE or die "Cannot open $image for reading: $!\n";

# Strip off any leading directory structure so outputs go to pwd

$image =~ s/.*\/(.*?)/$1/;

# Write out the kernel image

$buffer = "";

(my $kernel = $image) =~ s/^(.*)\.(.*?)$/$1.kernel/;
print "Writing $offset bytes to $kernel ...\n";
open(KERNEL, ">$kernel") and binmode KERNEL or die "Cannot open $kernel for writing: $!\n"; 
read(IMAGE, $buffer, $offset) and print KERNEL $buffer;
close(KERNEL);

# Write out the JFFS2 image

$buffer = "";

my $balance = $size - $offset;
(my $jffs2 = $image) =~ s/^(.*)\.(.*?)$/$1.jffs2/;
print "Writing $balance bytes to $jffs2 ...\n";
open(JFFS2, ">$jffs2") and binmode JFFS2 or die "Cannot open $jffs2 for writing: $!\n";
read(IMAGE, $buffer, $balance) and print JFFS2 $buffer;
close(IMAGE);

# You have to do a song and dance to mount a JFFS2 image

print "Mounting $jffs2 ...\n";
system("sudo mknod /tmp/mtdblock0 b 31 0");
system("sudo modprobe loop");
system("sudo losetup /dev/loop0 $jffs2");
system("sudo modprobe mtdblock");
system("sudo modprobe block2mtd");
# Note the ,128KiB is needed (on 2.6.26 at least) to set the eraseblock size
system("echo '/dev/loop0,128KiB' | sudo tee /sys/module/block2mtd/parameters/block2mtd > /dev/null");
system("sudo modprobe jffs2");
system("mkdir ./jffs2");
system("sudo mount -t jffs2 /tmp/mtdblock0 ./jffs2");

# Copy JFFS2 somewhere we can actually play with it

print "Copying JFFS2 filesystem so we can unmount it ...\n";
system("sudo cp -a ./jffs2 ./jffs2-local");

# Unmount the JFFS2 image, unwind MTD/loopback, and rename the unpacked directory tree

print "Unmounting $jffs2 ...\n";
system("sudo umount /tmp/mtdblock0");
print "Cleaning up ...\n";
system("sudo modprobe -r block2mtd");
system("sudo modprobe -r mtdblock");
system("sudo losetup -d /dev/loop0");
system("sudo rm /tmp/mtdblock0");
system("sudo rm -r ./jffs2 $jffs2");
system("sudo mv jffs2-local $jffs2");
