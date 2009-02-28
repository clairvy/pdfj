# pod2pdf.pl - PDFJ sample script
# 2002 <nakajima@netstock.co.jp>

# !!! CAUTION !!!
# This script must be Japanese EUC.

#--------------------------------------------------------------------
package PodPdf;

use PDFJ 'EUC';

use Pod::Parser;
#use Data::Dumper;
use strict;
use vars qw(@ISA);

@ISA = qw(Pod::Parser);

sub initialize {
	my($self) = @_;
	$self->SUPER::initialize();
	my $doc = PDFJ::Doc->new(1.2, 595, 842); # A4
	my $width = 595 - 72 - 72;
	my $height = 842 - 72 - 72;
	$self->{bodywidth} = $width;
	$self->{bodyheight} = $height;
	my $f_normal = $doc->new_font('Ryumin-Light', 'EUC-NEC-H', 'Times-Roman', 
		'WinAnsiEncoding', 1.05);
	my $f_italic = $doc->new_font('Ryumin-Light', 'EUC-NEC-H', 'Times-Italic',
		'WinAnsiEncoding', 1.05);
	my $f_bold = $doc->new_font('GothicBBB-Medium', 'EUC-NEC-H', 'Times-Bold',
		'WinAnsiEncoding', 1.05);
	my $f_bolditalic = 
		$doc->new_font('GothicBBB-Medium', 'EUC-NEC-H', 'Times-BoldItalic',
		'WinAnsiEncoding', 1.05);
	my $f_fix = $doc->new_font('GothicBBB-Medium', 'EUC-NEC-H');
	my $f_gothic = 
		$doc->new_font('GothicBBB-Medium', 'EUC-NEC-H', 'Helvetica',
		'WinAnsiEncoding', 1.05);
	$doc->italic($f_normal, $f_italic, $f_bold, $f_bolditalic);
	$doc->bold($f_normal, $f_bold, $f_italic, $f_bolditalic);
	$self->{pdfdoc} = $doc;
	$self->{tstyle} = {
		head1 => TStyle(font => $f_gothic, fontsize => 15, objalign => 'm'),
		head2 => TStyle(font => $f_gothic, fontsize => 13),
		defitem => TStyle(font => $f_gothic, fontsize => 10),
		normal => TStyle(font => $f_normal, fontsize => 10),
		fix => TStyle(font => $f_fix, fontsize => 10),
		footer => TStyle(font => $f_gothic, fontsize => 9),
	};
	$self->{pstyle} = {
		head1 => PStyle(size => $width, linefeed => '100%', align => 'b', preskip => 30, postskip => 15, nobreak => 1, postnobreak => 1),
		head2 => PStyle(size => $width, linefeed => '100%', align => 'b', preskip => 20, postskip => 10, nobreak => 1, postnobreak => 1),
		# defitem => PStyle(size => $width, linefeed => '100%', align => 'b', preskip => 10, postskip => 2.5, nobreak => 1, postnobreak => 1),
		defitem => PStyle(size => $width, linefeed => '100%', align => 'b', preskip => 10, postskip => 5, nobreak => 1, postnobreak => 1),
		# normal => PStyle(size => $width, linefeed => '150%', align => 'w', preskip => 2.5, postskip => 2.5),
		normal => PStyle(size => $width, linefeed => '150%', align => 'w', preskip => 5, postskip => 5),
		# verbatim => PStyle(size => $width, linefeed => '150%', align => 'w', preskip => 7.5, postskip => 7.5),
		verbatim => PStyle(size => $width, linefeed => '150%', align => 'w', preskip => 2.5, postskip => 2.5),
		footer => PStyle(size => $width, linefeed => '100%', align => 'm'),
	};
	$self->{listskip} = 5;
	$self->{head2mark} = '■';
	$self->{bullmark} = '・';
	$self->{indentunit} = 5;
}

sub pdfpara {
	my($self, $text, $stylename, $outlinelevel, $outlinetitle, $line) = @_;
	my $tstyle = $self->{tstyle}{$stylename} or 
		die "unknown style name $stylename\n";
	my $pstyle = $self->{pstyle}{$stylename} or 
		die "unknown style name $stylename\n";
	my @texts;
	push @texts, Shape->line(0, 0, $self->{bodywidth}, 0) if $line;
	if( defined $outlinelevel ) {
		$outlinetitle ||= $text;
		push @texts, Outline($outlinetitle, $outlinelevel), Dest($outlinetitle), 
			$text;
	} else {
		push @texts, $text;
	}
	Paragraph(Text([@texts], $tstyle), $pstyle);
}

sub add_pdfpara {
	my($self, $pdfpara) = @_;
	push @{$self->{pdfparas}}, $pdfpara;
}

sub status {
	my($self, $status) = @_;
	$self->{status} = $status if defined $status;
	$self->{status};
}

sub indent {
	my($self, $indent) = @_;
	$self->{indent} = $indent if defined $indent;
	$self->{indent} || 0;
}

sub itemnum {
	my($self, $itemnum) = @_;
	$self->{itemnum} = $itemnum if defined $itemnum;
	$self->{itemnum};
}

sub print {
	my($self, $file) = @_;
	$self->{pdfdoc}->print($file);
}

sub end_pod {
	my($self) = @_;
	my $block = Block('V', $self->{pdfparas}, BStyle());
	for my $part( $block->break($self->{bodyheight}) ) {
		my $page = $self->{pdfdoc}->new_page;
		print "page ", $page->pagenum, "\n";
		$part->show($page, 72, 72 + $self->{bodyheight});
		my $footer = $self->pdfpara($page->pagenum, 'footer');
		$footer->show($page, 72, 36);
	}
}

sub command {
	my($self, $command, $text, $linenum, $para) = @_;
	my $ptext = $text;
	$ptext =~ s/\n+$//;
	if( $command eq 'head1' ) {
		$self->status('normal');
		$self->add_pdfpara($self->pdfpara($ptext, 'head1', 0, $ptext, 1));
	} elsif( $command eq 'head2' ) {
		$self->status('normal');
		$self->add_pdfpara($self->pdfpara($self->{head2mark}.$ptext, 'head2', 
			1, $ptext));
	} elsif( $command eq 'over' ) {
		my($indent) = $ptext =~ /(\d+)/;
		$self->status('list');
		$self->indent($indent);
		$self->add_pdfpara($self->{listskip});
	} elsif( $command eq 'back' ) {
		$self->status('normal');
		$self->indent(0);
		$self->add_pdfpara($self->{listskip});
	} elsif( $command eq 'item' ) {
		if( $ptext eq '*' ) {
			$self->status('bullitem');
		} elsif( $ptext =~ /^(\d+.?)$/ ) {
			$self->status('numitem');
			$self->itemnum($1);
		} else {
			$self->add_pdfpara($self->pdfpara($ptext, 'defitem'));
			$self->status('normal');
		}
	}
}

sub verbatim {
	my($self, $text, $linenum, $para) = @_;
	return if $text =~ /^\s*$/;
	my $indent = $self->indent * $self->{indentunit};
	my $bpadding = 5;
	my $orgpstyle = $self->{pstyle}{verbatim};
	my $pstyle = $orgpstyle->
		clone(size => $orgpstyle->{size} - $indent - $bpadding * 2,
			align => 'b');
	$text =~ s/\n+$//s;
	my @paras;
	for my $line(split(/\n/, $text)) {
		my $lineindent = 0;
		if( $line =~ s/^(\s+)// ) {
			$lineindent = length($1) * $self->{indentunit};
		}
		push @paras, Paragraph(Text($line, $self->{tstyle}{fix}), 
			$pstyle->clone(beginindent => $lineindent));
	}
	my $bstyle = BStyle(blockalign => $indent, padding => $bpadding, 
		preskip => 7.5, postskip => 7.5,
		withbox => "f", withboxstyle => SStyle(fillcolor => Color(0.9)));
	my $blk = Block('V', @paras, $bstyle);
	$self->add_pdfpara($blk);
}

sub toText {
	my($self, $root) = @_;
	my @texts;
	for my $part(@{$root->{text}}) {
		if( ref($part) ) {
			push @texts, $self->toText($part);
		} else {
			push @texts, $part;
		}
	}
	if( $root->{cmd} ) {
		my $cmd = $root->{cmd};
		my $style = TStyle();
		if( $cmd eq 'I' || $cmd eq 'F' ) {
			$style->{italic} = 1;
		} elsif( $cmd eq 'B' ) {
			$style->{bold} = 1;
		} elsif( $cmd eq 'C' ) {
			$style->{font} = $self->{tstyle}{fix}{font};
		} elsif( $cmd eq 'L' ) {
			my $dest = $texts[0];
			my $ptext;
			($ptext, $dest) = split /\|/, $dest if $dest =~ /\|/;
			if( $dest =~ /^\/?\"(.+)\"$/ ) {
				$dest = $1;
				$dest = "URI:$dest" if $dest =~ /^(https?|ftp|mailto):/i;
				$style->{withbox} = 'b';
				$style->{withboxstyle} = SStyle(link => $dest);
				$ptext ||= $dest;
			} else {
				$ptext ||= $dest;
			}
			$texts[0] = $ptext;
		} elsif( $cmd eq 'X' ) {
			my $dest = $texts[0];
			$texts[0] = Dest($dest);
		}
		Text(@texts, $style);
	} else {
		@texts;
	}
}

sub myinterpolate {
	my($self, $text) = @_;
	my $root = {text => []};
	my $cur = $root;
	while( $text =~ /\x01.|\x02/ ) {
		my $left = $`;
		my $sep = $&;
		$text = $';
		push @{$cur->{text}}, $left if $left ne '';
		if( $sep eq "\x02" ) {
			$cur = $cur->{parent};
		} else {
			my $cmd = substr($sep, 1, 1);
			my $newcur = {parent => $cur, cmd => $cmd, text => []};
			push @{$cur->{text}}, $newcur;
			$cur = $newcur;
		}
	}
	push @{$cur->{text}}, $text if $text ne '';
	$self->toText($root);
}

sub textblock {
	my($self, $text, $linenum, $para) = @_;
	$text = $self->interpolate($text, $linenum);
	$text =~ s/\n+$//;
	$text =~ s/\n/ /g;
	my @texts = $self->myinterpolate($text);
	my $indent = $self->indent;
	my $pstyle;
	if( $self->status eq 'bullitem' ) {
		$pstyle = $self->{pstyle}{normal}->clone(
			labeltext => Text($self->{bullmark}, $self->{tstyle}{normal}), 
			labelsize => $indent * $self->{indentunit});
		$self->status('normal');
	} elsif( $self->status eq 'numitem' ) {
		$pstyle = $self->{pstyle}{normal}->clone(
			labeltext => Text($self->{itemnum}, $self->{tstyle}{normal}), 
			labelsize => $indent * $self->{indentunit});
		$self->status('normal');
	} else {
		$pstyle = $self->{pstyle}{normal}->
			clone(beginindent => $indent * $self->{indentunit});
	}
	$self->add_pdfpara(Paragraph(Text(@texts, $self->{tstyle}{normal}), $pstyle));
}

my %Esc = qw(lt < gt > sol / verbar |);
sub interior_sequence {
	my($self, $command, $text, $seq) = @_;
	if( $command =~ /^[IBCLFX]$/ ) {
		"\x01$command$text\x02";
	} elsif( $command eq 'E' ) {
		$Esc{$text} || $text;
	} else {
		$text;
	}
}

#--------------------------------------------------------------------
package PodPdf::SJIS2EUC;
use FileHandle;
use strict;

sub TIEHANDLE {
	my($class, $file) = @_;
	my $handle = new FileHandle $file or die "cannot open $file";
	bless {file => $file, handle => $handle}, $class;
}

sub READLINE {
	my $self = shift;
	my $handle = $self->{handle};
	my $line = <$handle>;
	sjis2euc($line);
}

my %extin = (
"\xFA\xAF" => "\xED\x93",
"\xFB\xE9" => "\xEE\xCD",
"\xFA\xEC" => "\xED\xD0",
"\xFB\x79" => "\xEE\x5D",
"\xFA\xF2" => "\xED\xD6",
"\xFA\xF3" => "\xED\xD7",
"\xFA\x8F" => "\xED\x72",
"\xFC\x4B" => "\xEE\xEC",
"\xFB\x7C" => "\xEE\x60",
"\xFA\xBD" => "\xED\xA1",
"\xFA\xB4" => "\xED\x98",
"\xFA\xB5" => "\xED\x99",
"\xFC\x48" => "\xEE\xE9",
"\xFB\x59" => "\xED\xFA",
"\xFA\xE9" => "\xED\xCD",
"\xFA\xFA" => "\xED\xDE",
"\xFA\xBE" => "\xED\xA2",
"\xFA\x81" => "\xED\x64",
"\xFC\x47" => "\xEE\xE8",
"\xFB\x73" => "\xEE\x57",
"\xFB\x71" => "\xEE\x55",
"\xFB\x72" => "\xEE\x56",
"\xFA\xEE" => "\xED\xD2",
"\xFB\x56" => "\xED\xF7",
"\xFA\xF4" => "\xED\xD8",
"\xFB\x57" => "\xED\xF8",
"\xFB\x7A" => "\xEE\x5E",
"\xFB\xA3" => "\xEE\x87",
"\xFB\x5B" => "\xED\xFC",
"\xFA\xB2" => "\xED\x96",
"\xFA\xF0" => "\xED\xD4",
"\xFA\x5D" => "\xED\x41",
"\xFA\x6D" => "\xED\x51",
"\xFB\x84" => "\xEE\x67",
"\xFA\xB6" => "\xED\x9A",
"\xFA\x69" => "\xED\x4D",
"\xFB\x5C" => "\xEE\x40",
"\xFB\xA6" => "\xEE\x8A",
"\xFA\x8C" => "\xED\x6F",
"\xFA\xF5" => "\xED\xD9",
"\xFA\xF1" => "\xED\xD5",
"\xFA\xAE" => "\xED\x92",
"\xFB\xED" => "\xEE\xD1",
"\xFA\x61" => "\xED\x45",
"\xFB\x41" => "\xED\xE2",
"\xFB\x55" => "\xED\xF6",
"\xFA\xB0" => "\xED\x94",
"\xFA\x73" => "\xED\x57",
"\xFA\x85" => "\xED\x68",
"\xFB\xEE" => "\xEE\xD2",
"\xFB\x7B" => "\xEE\x5F",
"\xFB\x5D" => "\xEE\x41",
"\xFB\x65" => "\xEE\x49",
"\xFB\x85" => "\xEE\x68",
"\xFB\x51" => "\xED\xF2",
"\xFB\xEF" => "\xEE\xD3",
"\xFA\xC6" => "\xED\xAA",
"\xFA\xF9" => "\xED\xDD",
"\xFA\xB7" => "\xED\x9B",
"\xFB\x87" => "\xEE\x6A",
"\xFB\xA7" => "\xEE\x8B",
"\xFA\xEB" => "\xED\xCF",
"\xFA\x6A" => "\xED\x4E",
"\xFB\xA4" => "\xEE\x88",
"\xFA\x6E" => "\xED\x52",
"\xFB\xF0" => "\xEE\xD4",
"\xFB\xF1" => "\xEE\xD5",
"\xFB\x93" => "\xEE\x76",
"\xFA\xCE" => "\xED\xB2",
"\xFB\xB8" => "\xEE\x9C",
"\xFB\x60" => "\xEE\x44",
"\xFA\xF6" => "\xED\xDA",
"\xFA\xCC" => "\xED\xB0",
"\xFB\x5A" => "\xED\xFB",
"\xFA\xB3" => "\xED\x97",
"\xFA\x8D" => "\xED\x70",
"\xFA\xBA" => "\xED\x9E",
"\xFA\x94" => "\xED\x77",
"\xFA\xD1" => "\xED\xB5",
"\xFB\xF2" => "\xEE\xD6",
"\xFB\xE8" => "\xEE\xCC",
"\xFB\xF3" => "\xEE\xD7",
"\xFA\xB8" => "\xED\x9C",
"\xFB\x42" => "\xED\xE3",
"\xFB\x48" => "\xED\xE9",
"\xFA\xC9" => "\xED\xAD",
"\xFB\x61" => "\xEE\x45",
"\xFA\x40" => "\xEE\xEF",
"\xFA\x41" => "\xEE\xF0",
"\xFB\xA2" => "\xEE\x86",
"\xFA\x42" => "\xEE\xF1",
"\xFB\x8D" => "\xEE\x70",
"\xFA\x43" => "\xEE\xF2",
"\xFB\x6E" => "\xEE\x52",
"\xFA\x57" => "\xEE\xFC",
"\xFA\x44" => "\xEE\xF3",
"\xFA\x45" => "\xEE\xF4",
"\xFA\x46" => "\xEE\xF5",
"\xFA\x98" => "\xED\x7B",
"\xFA\x47" => "\xEE\xF6",
"\xFB\xC1" => "\xEE\xA5",
"\xFA\x48" => "\xEE\xF7",
"\xFA\xCF" => "\xED\xB3",
"\xFA\x56" => "\xEE\xFB",
"\xFA\x49" => "\xEE\xF8",
"\xFB\xB9" => "\xEE\x9D",
"\xFB\x67" => "\xEE\x4B",
"\xFA\xF8" => "\xED\xDC",
"\xFB\x69" => "\xEE\x4D",
"\xFB\xF8" => "\xEE\xDC",
"\xFB\xC3" => "\xEE\xA7",
"\xFA\xDB" => "\xED\xBF",
"\xFB\x68" => "\xEE\x4C",
"\xFB\x64" => "\xEE\x48",
"\xFB\x6A" => "\xEE\x4E",
"\xFA\x92" => "\xED\x75",
"\xFA\xD3" => "\xED\xB7",
"\xFB\xA8" => "\xEE\x8C",
"\xFB\x4A" => "\xED\xEB",
"\xFB\x62" => "\xEE\x46",
"\xFA\x67" => "\xED\x4B",
"\xFA\x76" => "\xED\x5A",
"\xFB\x46" => "\xED\xE7",
"\xFB\xC2" => "\xEE\xA6",
"\xFA\xCA" => "\xED\xAE",
"\xFB\x49" => "\xED\xEA",
"\xFB\xB6" => "\xEE\x9A",
"\xFA\xD4" => "\xED\xB8",
"\xFB\x8C" => "\xEE\x6F",
"\xFA\x77" => "\xED\x5B",
"\xFB\xF4" => "\xEE\xD8",
"\xFB\x81" => "\xEE\x64",
"\xFA\xDC" => "\xED\xC0",
"\xFB\x63" => "\xEE\x47",
"\xFA\xDF" => "\xED\xC3",
"\xFB\xCC" => "\xEE\xB0",
"\xFA\xD2" => "\xED\xB6",
"\xFA\xBB" => "\xED\x9F",
"\xFA\xCD" => "\xED\xB1",
"\xFA\x91" => "\xED\x74",
"\xFA\x9A" => "\xED\x7D",
"\xFA\xF7" => "\xED\xDB",
"\xFA\x99" => "\xED\x7C",
"\xFA\x75" => "\xED\x59",
"\xFB\x83" => "\xEE\x66",
"\xFB\xEB" => "\xEE\xCF",
"\xFB\xDE" => "\xEE\xC2",
"\xFA\x63" => "\xED\x47",
"\xFB\x44" => "\xED\xE5",
"\xFB\x4C" => "\xED\xED",
"\xFA\x70" => "\xED\x54",
"\xFA\xDD" => "\xED\xC1",
"\xFB\xAA" => "\xEE\x8E",
"\xFB\xB5" => "\xEE\x99",
"\xFA\xFC" => "\xED\xE0",
"\xFB\x43" => "\xED\xE4",
"\xFA\x95" => "\xED\x78",
"\xFC\x46" => "\xEE\xE7",
"\xFB\xF5" => "\xEE\xD9",
"\xFB\xAF" => "\xEE\x93",
"\xFA\x9F" => "\xED\x83",
"\xFA\x9E" => "\xED\x82",
"\xFA\xD0" => "\xED\xB4",
"\xFB\xAB" => "\xEE\x8F",
"\xFB\x45" => "\xED\xE6",
"\xFA\xA8" => "\xED\x8C",
"\xFB\xBB" => "\xEE\x9F",
"\xFA\x6F" => "\xED\x53",
"\xFB\x66" => "\xEE\x4A",
"\xFB\x96" => "\xEE\x79",
"\xFA\x72" => "\xED\x56",
"\xFB\x8A" => "\xEE\x6D",
"\xFA\xB9" => "\xED\x9D",
"\xFB\xA5" => "\xEE\x89",
"\xFC\x44" => "\xEE\xE5",
"\xFB\xBA" => "\xEE\x9E",
"\xFA\xE5" => "\xED\xC9",
"\xFB\xFB" => "\xEE\xDF",
"\xFB\xBC" => "\xEE\xA0",
"\xFB\x47" => "\xED\xE8",
"\xFA\x71" => "\xED\x55",
"\xFB\x8E" => "\xEE\x71",
"\xFB\xFC" => "\xEE\xE0",
"\xFB\xCA" => "\xEE\xAE",
"\xFB\x5F" => "\xEE\x43",
"\xFA\x96" => "\xED\x79",
"\xFC\x45" => "\xEE\xE6",
"\xFB\xC4" => "\xEE\xA8",
"\xFC\x40" => "\xEE\xE1",
"\xFB\xE1" => "\xEE\xC5",
"\xFB\xDD" => "\xEE\xC1",
"\xFB\xC6" => "\xEE\xAA",
"\xFB\xDB" => "\xEE\xBF",
"\xFB\x99" => "\xEE\x7C",
"\xFB\xBF" => "\xEE\xA3",
"\xFA\xA4" => "\xED\x88",
"\xFB\xC0" => "\xEE\xA4",
"\xFB\x74" => "\xEE\x58",
"\xFA\x74" => "\xED\x58",
"\xFA\xFB" => "\xED\xDF",
"\xFA\x7A" => "\xED\x5E",
"\xFB\xD8" => "\xEE\xBC",
"\xFB\xC5" => "\xEE\xA9",
"\xFA\x78" => "\xED\x5C",
"\xFB\x91" => "\xEE\x74",
"\xFA\xE2" => "\xED\xC6",
"\xFB\xD7" => "\xEE\xBB",
"\xFB\xBD" => "\xEE\xA1",
"\xFB\x6B" => "\xEE\x4F",
"\xFB\x8B" => "\xEE\x6E",
"\xFB\xBE" => "\xEE\xA2",
"\xFA\x97" => "\xED\x7A",
"\xFB\x88" => "\xEE\x6B",
"\xFA\xD6" => "\xED\xBA",
"\xFA\xD7" => "\xED\xBB",
"\xFB\xD2" => "\xEE\xB6",
"\xFA\xE4" => "\xED\xC8",
"\xFA\x7D" => "\xED\x61",
"\xFB\xD6" => "\xEE\xBA",
"\xFB\xD4" => "\xEE\xB8",
"\xFB\xC7" => "\xEE\xAB",
"\xFB\xD0" => "\xEE\xB4",
"\xFA\xCB" => "\xED\xAF",
"\xFB\xD1" => "\xEE\xB5",
"\xFB\x40" => "\xED\xE1",
"\xFA\x84" => "\xED\x67",
"\xFA\x82" => "\xED\x65",
"\xFB\xC9" => "\xEE\xAD",
"\xFA\xA5" => "\xED\x89",
"\xFB\x94" => "\xEE\x77",
"\xFB\xAC" => "\xEE\x90",
"\xFA\xD5" => "\xED\xB9",
"\xFB\x98" => "\xEE\x7B",
"\xFB\xC8" => "\xEE\xAC",
"\xFA\x86" => "\xED\x69",
"\xFB\x9E" => "\xEE\x82",
"\xFB\xD5" => "\xEE\xB9",
"\xFB\x8F" => "\xEE\x72",
"\xFA\x55" => "\xEE\xFA",
"\xFB\xE2" => "\xEE\xC6",
"\xFB\xCF" => "\xEE\xB3",
"\xFB\x97" => "\xEE\x7A",
"\xFA\x89" => "\xED\x6C",
"\xFA\xC3" => "\xED\xA7",
"\xFB\x4E" => "\xED\xEF",
"\xFB\x4F" => "\xED\xF0",
"\xFB\x77" => "\xEE\x5B",
"\xFA\x8A" => "\xED\x6D",
"\xFB\xAD" => "\xEE\x91",
"\xFA\x60" => "\xED\x44",
"\xFA\xDE" => "\xED\xC2",
"\xFA\x66" => "\xED\x4A",
"\xFB\xAE" => "\xEE\x92",
"\xFA\xD9" => "\xED\xBD",
"\xFB\x4D" => "\xED\xEE",
"\xFB\xCB" => "\xEE\xAF",
"\xFA\x5E" => "\xED\x42",
"\xFA\x7E" => "\xED\x62",
"\xFA\x90" => "\xED\x73",
"\xFB\x6C" => "\xEE\x50",
"\xFA\x9B" => "\xED\x7E",
"\xFA\x7C" => "\xED\x60",
"\xFA\x9C" => "\xED\x80",
"\xFB\x6F" => "\xEE\x53",
"\xFB\x90" => "\xEE\x73",
"\xFB\x95" => "\xEE\x78",
"\xFA\xC1" => "\xED\xA5",
"\xFA\xB1" => "\xED\x95",
"\xFA\x64" => "\xED\x48",
"\xFA\xD8" => "\xED\xBC",
"\xFA\x65" => "\xED\x49",
"\xFA\xE8" => "\xED\xCC",
"\xFA\x79" => "\xED\x5D",
"\xFA\xEA" => "\xED\xCE",
"\xFB\x58" => "\xED\xF9",
"\xFB\x5E" => "\xEE\x42",
"\xFB\x75" => "\xEE\x59",
"\xFB\x7D" => "\xEE\x61",
"\xFB\xE5" => "\xEE\xC9",
"\xFB\x7E" => "\xEE\x62",
"\xFB\xD9" => "\xEE\xBD",
"\xFB\xE3" => "\xEE\xC7",
"\xFA\xA0" => "\xED\x84",
"\xFA\xE6" => "\xED\xCA",
"\xFB\xDC" => "\xEE\xC0",
"\xFA\xE7" => "\xED\xCB",
"\xFB\xE0" => "\xEE\xC4",
"\xFB\xCD" => "\xEE\xB1",
"\xFA\xE1" => "\xED\xC5",
"\xFB\x80" => "\xEE\x63",
"\xFB\xCE" => "\xEE\xB2",
"\xFA\x87" => "\xED\x6A",
"\xFB\x82" => "\xEE\x65",
"\xFB\x86" => "\xEE\x69",
"\xFB\x89" => "\xEE\x6C",
"\xFB\x92" => "\xEE\x75",
"\xFB\x9D" => "\xEE\x81",
"\xFA\xC0" => "\xED\xA4",
"\xFC\x42" => "\xEE\xE3",
"\xFA\xA1" => "\xED\x85",
"\xFB\xB2" => "\xEE\x96",
"\xFC\x41" => "\xEE\xE2",
"\xFA\xA2" => "\xED\x86",
"\xFC\x4A" => "\xEE\xEB",
"\xFB\x9F" => "\xEE\x83",
"\xFB\xA0" => "\xEE\x84",
"\xFA\xC5" => "\xED\xA9",
"\xFA\xA7" => "\xED\x8B",
"\xFA\xE0" => "\xED\xC4",
"\xFB\x52" => "\xED\xF3",
"\xFB\x6D" => "\xEE\x51",
"\xFB\xA9" => "\xEE\x8D",
"\xFB\xB1" => "\xEE\x95",
"\xFA\xC7" => "\xED\xAB",
"\xFB\x4B" => "\xED\xEC",
"\xFB\x54" => "\xED\xF5",
"\xFB\xB3" => "\xEE\x97",
"\xFB\xB4" => "\xEE\x98",
"\xFA\xAB" => "\xED\x8F",
"\xFA\x8B" => "\xED\x6E",
"\xFA\x83" => "\xED\x66",
"\xFB\xB7" => "\xEE\x9B",
"\xFA\xBF" => "\xED\xA3",
"\xFA\xAC" => "\xED\x90",
"\xFB\xFA" => "\xEE\xDE",
"\xFB\xD3" => "\xEE\xB7",
"\xFA\x80" => "\xED\x63",
"\xFB\xDA" => "\xEE\xBE",
"\xFA\xC4" => "\xED\xA8",
"\xFB\x50" => "\xED\xF1",
"\xFB\xEA" => "\xEE\xCE",
"\xFB\x78" => "\xEE\x5C",
"\xFA\xE3" => "\xED\xC7",
"\xFB\x9A" => "\xEE\x7D",
"\xFB\xE6" => "\xEE\xCA",
"\xFA\xA3" => "\xED\x87",
"\xFB\x76" => "\xEE\x5A",
"\xFB\xE7" => "\xEE\xCB",
"\xFB\xF6" => "\xEE\xDA",
"\xFA\xED" => "\xED\xD1",
"\xFB\xF7" => "\xEE\xDB",
"\xFA\x5F" => "\xED\x43",
"\xFB\x9B" => "\xEE\x7E",
"\xFB\xF9" => "\xEE\xDD",
"\xFA\x8E" => "\xED\x71",
"\xFC\x49" => "\xEE\xEA",
"\xFA\xDA" => "\xED\xBE",
"\xFB\x53" => "\xED\xF4",
"\xFA\xC8" => "\xED\xAC",
"\xFA\xBC" => "\xED\xA0",
"\xFB\xB0" => "\xEE\x94",
"\xFB\xE4" => "\xEE\xC8",
"\xFA\x62" => "\xED\x46",
"\xFA\x88" => "\xED\x6B",
"\xFA\x7B" => "\xED\x5F",
"\xFB\xDF" => "\xEE\xC3",
"\xFA\xA9" => "\xED\x8D",
"\xFA\x5C" => "\xED\x40",
"\xFB\xA1" => "\xEE\x85",
"\xFC\x43" => "\xEE\xE4",
"\xFA\x6B" => "\xED\x4F",
"\xFA\xAD" => "\xED\x91",
"\xFA\x6C" => "\xED\x50",
"\xFA\xC2" => "\xED\xA6",
"\xFA\xEF" => "\xED\xD3",
"\xFA\xA6" => "\xED\x8A",
"\xFA\x68" => "\xED\x4C",
"\xFA\x93" => "\xED\x76",
"\xFB\x9C" => "\xEE\x80",
"\xFA\x9D" => "\xED\x81",
"\xFB\xEC" => "\xEE\xD0",
"\xFB\x70" => "\xEE\x54",
"\xFA\xAA" => "\xED\x8E",
);

sub _sjis2euc {
	my($c1,$c2) = @_;
	
	$c1 = ord($c1);
	$c2 = ord($c2);
	chr((($c1 - ($c1 < 160 ? 112 : 176)) << 1) - ($c2 < 159) + 128)
	 . chr($c2 - (($c2 < 159) ? ($c2 > 127 ? 32 : 31) : 126) + 128);
}

sub sjis2euc {
	my($string) = @_;
	my ($j,$c,$c2,@c);
	my $ctype = '1';	# 1:ASCII  K:半角カナ  2:2バイト文字
	my $result;
	
	@c = split(//,$string);
	for( $j = 0; $j <= $#c; $j++ ) {
		$c = $c[$j];
		if( $c =~ /[\x00-\x7f]/ ) { 
			$result .= $c; 
		} elsif( $c =~ /[\x81-\x9f\xe0-\xef]/ ) {
			last if( ++$j > $#c ); $c2 = $c[$j];
			if( $c2 =~ /[\x40-\xfc]/ ) { 
				$result .= _sjis2euc($c,$c2); 
			} else { 
				$result .= $c . $c2; 
			}
		} elsif( $c ge "\xfa" ) {
			last if( ++$j > $#c ); $c2 = $c[$j];
			if( $extin{$c.$c2} ) { 
				$result .= _sjis2euc(split(//, $extin{$c.$c2})); 
			} else { 
				$result .= "\xa2\xa3"; 
			} 
		} elsif( $c =~ /[\xa1-\xdf]/ ) { 
			$result .= "\x8e" . $c; 
		} else { 
			$result .= $c; 
		}
	}
	$result;
}

#--------------------------------------------------------------------
package main;
use Getopt::Std;
use strict;

my %Opt;
getopts 'se', \%Opt;

my($Infile, $Outfile) = @ARGV;
if( $Opt{s} ) {
	tie *IN, 'PodPdf::SJIS2EUC', $Infile;
} else {
	open IN, $Infile or die "cannot open $Infile";
}

my $podpdf = new PodPdf;
$podpdf->parse_from_filehandle(*IN);
$podpdf->print($Outfile);

