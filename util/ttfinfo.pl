# ttf.pl - glance a TrueType font 
# 2002 Sey <nakajima@netstock.co.jp>
# perl ttf.pl foo.ttf
# output: foo.ttf.info

use PDFJ::TTF;
use FileHandle;
use strict;

my $file = shift;
my $enc = shift;
my $ttf = new PDFJ::TTF $file;
my $out = $enc ? "$file.info.$enc" : "$file.info";
my $outhandle = FileHandle->new(">$out");
$ttf->read_table(':all');
$ttf->dump($outhandle, 1);
if( $enc ) {
	my $pdfinfo = $ttf->pdf_info_ascii($enc);
	PDFJ::TTF::_dump($outhandle, "", $pdfinfo);
}
