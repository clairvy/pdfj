# nouhinsho.pl - PDFJ �T���v���X�N���v�g - �[�i���쐬
# 2002 <nakajima@netstock.co.jp>
# perl nouhinsho.pl �f�[�^�t�@�C�� �o�̓t�@�C��
package Nouhinsho;
use PDFJ 'SJIS';
use strict;

# �e��̃p�����[�^�[
my @me = ( # ���Е\��
	'�i���j�l�b�g�X�g�b�N', NewLine, 
	'�����s��c�抗�cXX-YYY', NewLine, 
	'03-XXXX-YYYY'
);
my @pagesize = (595, 842); # A4�c
my $bodypadding = 72; # �y�[�W�]��
my $bodywidth = $pagesize[0] - $bodypadding * 2; # �\���̈敝
my $bodyheight = $pagesize[1] - $bodypadding * 2; # �\���̈捂��
my %cellwidth;
$cellwidth{name} = 200; # ���̗���
$cellwidth{quantity} = 50; # ���ʗ���
$cellwidth{note} = $bodywidth - $cellwidth{name} - $cellwidth{quantity}; # �E�v����
my $cellpadding = 5; # �Z�����]��
my $normalfontsize = 10; # �t�H���g�T�C�Y
my $bigfontsize = 15; # �t�H���g�T�C�Y��

# �R���X�g���N�^
sub new {
	my($class) = @_;
	my $self = bless {}, $class;
	$self->initialize;
	$self;
}

# ������
# �����I�u�W�F�N�g�A�t�H���g�I�u�W�F�N�g�A�e�L�X�g�X�^�C�����쐬
sub initialize {
	my($self) = @_;
	my $doc = PDFJ::Doc->new(1.2, @pagesize);
	$self->{doc} = $doc;
	$self->{font}{mincho} = 
		$doc->new_font('Ryumin-Light', '90ms-RKSJ-H', 'Times-Roman',
		'WinAnsiEncoding', 1.05);
	$self->{font}{gothic} = 
		$doc->new_font('GothicBBB-Medium', '90ms-RKSJ-H', 'Helvetica',
		'WinAnsiEncoding', 1.05);
	$self->{tstyle}{mincho} = 
		TStyle(font => $self->{font}{mincho}, fontsize => $normalfontsize);
	$self->{tstyle}{gothic} = 
		TStyle(font => $self->{font}{gothic}, fontsize => $normalfontsize);
	$self->{tstyle}{gothicbig} = 
		TStyle(font => $self->{font}{gothic}, fontsize => $bigfontsize);
}

# �w�b�_���Ŏg����i�����쐬���ĕԂ�
# headerpara(�e�L�X�g�X�^�C����, �z�u, preskip, postskip, �����񃊃X�g)
sub headerpara {
	my($self, $tstylename, $align, $preskip, $postskip, @str) = @_;
	Paragraph(Text(@str, $self->{tstyle}{$tstylename}),
		PStyle(size => $bodywidth, linefeed => '120%', align => $align,
			preskip => $preskip, postskip => $postskip));
}

# �w�b�_�u���b�N���쐬
# makeheader(���t, �ڋq��)
sub makeheader {
	my($self, $date, $customer) = @_;
	$self->{header} = Block('V',
		$self->headerpara('gothicbig', 'm', 20, 20, '�[�i��'),
		$self->headerpara('mincho', 'e', 5, 5, $date),
		$self->headerpara('gothicbig', 'b', 10, 10, 
			Text($customer, TStyle(withline => 1))),
		$self->headerpara('mincho', 'e', 5, 5, @me),
		BStyle());
}

# �Z���Ŏg����i���X�^�C�����쐬���ĕԂ�
# cellpstyle(�Z����, �z�u)
sub cellpstyle {
	my($self, $cellname, $align) = @_;
	PStyle(size => $cellwidth{$cellname} - $cellpadding * 2, linefeed => '120%',
		align => $align);
}

# �Z���u���b�N���쐬���ĕԂ�
# cellblock(�e�L�X�g�X�^�C����, �Z����, �z�u, �����񃊃X�g)
sub cellblock {
	my($self, $tstylename, $cellname, $align, @str) = @_;
	my $withbox = $cellname eq 'quantity' ? 'lr' : '';
	Block('V', Paragraph(Text(@str, $self->{tstyle}{$tstylename}), 
		$self->cellpstyle($cellname, $align)),
		BStyle(padding => $cellpadding, withbox => $withbox, 
		withboxstyle => SStyle(linewidth => 0.5)));
}

# �\�u���b�N���쐬
# maketable(�f�[�^�z��Q��)
# �f�[�^�z��Q�Ƃ̗v�f�� [����, ����, �E�v]
sub maketable {
	my($self, $dataarray) = @_;
	my @rows;
	# ���o���s
	push @rows, Block('H',
		$self->cellblock('gothic', 'name', 'm', '����'),
		$self->cellblock('gothic', 'quantity', 'm', '����'),
		$self->cellblock('gothic', 'note', 'm', '�E�v'),
		BStyle(adjust => 1, postnobreak => 1, withbox => 'b', 
			withboxstyle => SStyle(linewidth => 0.5)));
	# �f�[�^�s
	for my $data(@$dataarray) {
		my($name, $quantity, $note) = @$data;
		push @rows, Block('H',
			$self->cellblock('mincho', 'name', 'b', $name),
			$self->cellblock('mincho', 'quantity', 'e', $quantity),
			$self->cellblock('mincho', 'note', 'b', $note),
			BStyle(adjust => 1));
	}
	$self->{table} = Block('V', @rows, BStyle(repeatheader => 1, 
		withbox => 'sr5', 
		withboxstyle => SStyle(linewidth => 1)));
}

# �w�b�_�u���b�N�ƕ\�u���b�N���y�[�W�ɔz�u����
sub makepage {
	my($self) = @_;
	my $doc = $self->{doc};
	# ��̃u���b�N�ɂ܂Ƃ߂���ŁA
	my $pageblock = Block('V', $self->{header}, 20, $self->{table}, BStyle());
	# �\���̈�̍����ŕ������A
	my @blocks = $pageblock->break($bodyheight);
	# �e�u���b�N���y�[�W�ɔz�u
	my $pages = @blocks;
	for my $block(@blocks) {
		my $page = $doc->new_page;
		$block->show($page, $bodypadding, $bodypadding + $bodyheight, 'tl');
		# �y�[�W�㕔�Ƀy�[�W�ԍ���\��
		my $header = $self->headerpara('mincho', 'e', 0, 0, 
			$page->pagenum . "/$pages �y�[�W");
		$header->show($page, $bodypadding, $bodypadding + $bodyheight + 
			$bodypadding / 2, 'tl');
	}
}

# �o��
# print(�t�@�C����)
sub print {
	my($self, $file) = @_;
	$self->{doc}->print($file);
}

#-----------------------------------------------------------
package main;

my($datafile, $pdffile) = @ARGV;

# �f�[�^�t�@�C����ǂ݂Ƃ�
open D, $datafile or die;
# �P�s�ځF���t
my $date = <D>;
chomp $date;
# �Q�s�ځF�ڋq��
my $customer = <D>;
chomp $customer;
# �R�s�ڈȍ~�F���� �^�u ���� �^�u �E�v
my @data;
while(<D>) {
	chomp;
	my($name, $quantity, $note) = split "\t";
	push @data, [$name, $quantity, $note];
}
close D;

# �[�i�����쐬
my $nouhinsho = new Nouhinsho;
$nouhinsho->makeheader($date, $customer);
$nouhinsho->maketable(\@data);
$nouhinsho->makepage;
$nouhinsho->print($pdffile);
