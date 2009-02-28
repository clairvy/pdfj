#!/usr/bin/perl
# xpdfj.pl - XPDFJ sample script
# 2003 <nakajima@netstock.co.jp>
use XPDFJ;
use Getopt::Std;

getopt 'dvp';
$opt_d ||= 0;
$opt_v ||= 0;
$opt_p ||= '';
my $file = shift;
my $outfile;
my %args;
for(@ARGV) {
  if( /=/ ) {
    my($key, $value) = split /=/, $_, 2;
    $value = 1 unless defined $value;
    $args{$key} = $value;
  } elsif( !defined $outfile ) {
    $outfile = $_;
  }
}
$outfile ||= "$file.pdf";
my $xpdfj = XPDFJ->new(debuginfo => $opt_d, verbose => $opt_v, dopath => $opt_p);
$xpdfj->parsefile($file, outfile => $outfile, %args);
