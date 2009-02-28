# otfinfo.pl - glance a OpenType font 
# 2005 Sey <nakajima@netstock.co.jp>
# perl otfinfo.pl foo.otf
# output: foo.otf.info

use PDFJ::OTF;
use FileHandle;
use strict;

my $file = shift;
my $enc = shift;
my $otf = new PDFJ::OTF $file;
my $out = $enc ? "$file.info.$enc" : "$file.info";
my $outhandle = FileHandle->new(">$out");
$otf->read_table(':all');
$otf->dump($outhandle, 1);
if( $enc ) {
	my $pdfinfo = $otf->pdf_info_ascii($enc);
	PDFJ::TTF::_dump($outhandle, "", $pdfinfo);
}
