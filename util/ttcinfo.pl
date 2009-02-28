# ttc.pl - glance a TrueType Collection font 
# 2002 Sey <nakajima@netstock.co.jp>
# perl ttc.pl foo.ttc option
# option: -n : name only
# output: foo.ttc.info (no options)
#         stdout for -n option

use PDFJ::TTF;
use FileHandle;
use strict;

my $file = shift;
my $opt = shift;
my $ttc = new PDFJ::TTC $file;
my $out = $opt ? "-" : "$file.info";
my $outhandle = FileHandle->new(">$out");
my $fonts = $ttc->fonts;
print $outhandle "$fonts fonts in $file\n";
for( my $j = 0; $j < $fonts; $j++ ) {
	if( $opt eq '-n' ) {
		my $ttf = $ttc->select($j);
		$ttf->read_table('name');
		my $name = $ttf->find_name(1,0,6);
		print $outhandle "[$j] $name\n";
	} else {
		print $outhandle "\n[$j]\n";
		my $ttf = $ttc->select($j);
		$ttf->read_table(':all');
		$ttf->dump($outhandle, 1);
	}
}
