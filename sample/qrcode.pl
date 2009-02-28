# qrcode.pl - PDFJ sample script 
# 2004 <nakajima@netstock.co.jp>
use PDFJ;
use GD::Barcode::QRcode;
use strict;

my($text, $ecc, $version, $outfile) = @ARGV;
my $gb = GD::Barcode::QRcode->new($text, {Ecc => $ecc, Version => $version}) 
	or die $GD::Barcode::QRcode::errStr;
my $qr = qrcode_shape($gb->barcode);
my $doc = PDFJ::Doc->new(1.3, 200, 200);
my $page = $doc->new_page;
$qr->show($page, 10, 10);
$doc->print($outfile);

sub qrcode_shape {
	my($ptn, $unit) = @_;
	$unit ||= 3;
	my $shape = Shape(SStyle(linewidth => 0.01));
	my $x = 0;
	my @lines = split(/\n/, $ptn);
	my $y = $unit * (@lines - 1);
	for my $line(@lines) {
		for my $ch(split(//, $line)) {
			$shape->box($x, $y, $unit, $unit, ($ch ? 'f' : 'n'));
			$x += $unit;
		}
		$x = 0;
		$y -= $unit;
	}
	$shape;
}
