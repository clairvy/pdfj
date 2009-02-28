# barcode.pl - PDFJ sample script 
# 2004 <nakajima@netstock.co.jp>
use PDFJ;
use GD::Barcode;
use strict;

my($text, $type, $outfile) = @ARGV;
my $gb = GD::Barcode->new($type, $text) or die $GD::Barcode::errStr;
my $bar = barcode_shape($gb->barcode);
my $doc = PDFJ::Doc->new(1.3, 200, 100);
my $page = $doc->new_page;
$bar->show($page, 10, 10);
$doc->print($outfile);

sub barcode_shape {
	my($ptn, $linewidth, $height) = @_;
	$linewidth ||= 1;
	$height ||= 50;
	my $shape = Shape(SStyle(linewidth => $linewidth));
	my $pos = 0;
	for my $ch(split(//, $ptn)) {
		if($ch eq '0') {
		} elsif ($ch eq 'G') {
			$shape->line($pos, 0, 0, $height);
		} else {
			$shape->line($pos, 0, 0, $height);
		}
		$pos += $linewidth;
	}
	$shape;
}
