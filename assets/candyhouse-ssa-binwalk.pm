package Binwalk;

our $VERSION = '0.0.1';

use warnings;
use strict;

our $DEBUG = 1;

sub new 
{
   my $class = shift;
   my $self = {
      _file => shift,
   };
   bless $self, $class;
   $self->_parse;
   return $self;
}

sub parts
{
   my $self = shift;
   return($self->{_parts});
}

sub _parse 
{
   my $self = shift;
   print "Binwalking $self->{_file} ...\n" if $DEBUG;
   my @lines = `binwalk $self->{_file}` or die "Cannot binwalk $self->{_file}: $!\n";
   print @lines if $DEBUG > 1;
   foreach my $line (@lines)
   {
      chomp($line);
      if($line =~ /^(\S+)\s{2,}(\S+)\s{2,}(.*?)$/) { 
	 my($dec, $hex, $desc) = split(/\s{2,}/, $line);
	 my $part;
	 $part->{dec} = $dec;
	 $part->{hex} = $hex;
	 $part->{desc} = $desc;
	 push(@{$self->{_parts}}, $part);
      }
   }
}
