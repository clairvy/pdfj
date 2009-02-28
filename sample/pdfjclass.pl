# pdfjclass.pl - PDFJ�c���[�u���b�N�T���v���X�N���v�g - PDFJ�N���X�}
# 2005 <nakajima@netstock.co.jp>
use PDFJ;

# ����use�͒ʏ�͕K�v�Ȃ����A�V���{���e�[�u������N���X�c���[�����K�v��
use PDFJ::Matrix;
use PDFJ::Tree;
use PDFJ::Form;

use strict;

# �p�����[�^
my @Pagesize = (595, 842); # A4�c
my $Margin = 42; # 1.5cm
my $Fontsize = 10;
my $TitleFontsize = 14;
my @Color = qw(#FFDDEE #EEFFDD #DDEEFF #FFEEDD #EEDDFF #DDFFEE);
my $StartPKG = 'PDFJ'; # PDFJ::�Ŏn�܂�N���X��Ώۂɂ���

# �����I�u�W�F�N�g�ƃt�H���g
my $Doc = PDFJ::Doc->new(1.2, @Pagesize);
my $Font = $Doc->new_font('Ryumin-Light', '90ms-RKSJ-H', 'Times-Roman');

# �������
$Doc->add_info(Title => 'PDFJ Tree Block demo', 
	Author => '<nakajima@netstock.co.jp>');

# �c���[�f�[�^���쐬
my $tree = makeclasstree($StartPKG);

# ���ʂ̃c���[�X�^�C��
my $page1 = $Doc->new_page;
Block('V',
	# �\��
	Text('PDFJ Classes', TStyle(font => $Font, fontsize => $TitleFontsize)),
	Space(20),
	# �c���[�i�������j
	Block('TH', $tree, BStyle(adjust => 'l', 
		siblingalign => 'm', connectline => 'c', 
		levelskip => 20, siblingskip => 3)),
	BStyle())
	->show($page1, $Margin, $Pagesize[1] - $Margin, 'tl');

# �ʂ̃c���[�X�^�C��
my $page2 = $Doc->new_page;
Block('V',
	# �\��
	Text('PDFJ Classes (another style)', 
		TStyle(font => $Font, fontsize => $TitleFontsize)),
	Space(20),
	# �c���[�i�������j
	Block('TH', $tree, BStyle(adjust => 'ls', 
		levelskip => 5, siblingskip => 3)),
	BStyle())
	->show($page2, $Margin, $Pagesize[1] - $Margin, 'tl');

# �o��
$Doc->print('pdfjclass.pdf');

# �e�N���X��������u���b�N
sub classblock {
	my($classname, $color) = @_;
	my $text = Text($classname, TStyle(font => $Font, fontsize => $Fontsize));
	Block('V', 
		$text,
		BStyle(withbox => "sf", 
		withboxstyle => SStyle(fillcolor => Color($color)), padding => "3"));
}

# �c���[�u���b�N�p�ɃN���X�c���[���쐬
sub makeclasstree {
	my($pkg) = @_;
	my $isa = {};
	my $p2c = {};
	isatable($pkg, $pkg, $isa, $p2c);
	my @tree;
	my $colnum = 0;
	my $colors = @Color;
	for my $parent(sort keys %$p2c) {
		next if $isa->{$parent};
		push @tree, _makeclasstree($p2c, $parent, $Color[$colnum]);
		$colnum = ($colnum + 1) % $colors;
	}
	\@tree;
}

# �ċA�I�Ƀc���[���쐬
sub _makeclasstree {
	my($p2c, $parent, $color) = @_;
	my @children;
	for my $child( sort @{$p2c->{$parent}} ) {
		if( $p2c->{$child} ) {
			push @children, _makeclasstree($p2c, $child, $color);
		} else {
			push @children, classblock($child, $color);
		}
	}
	(classblock($parent, $color), \@children);
}

# �p�b�P�[�W�V���{���e�[�u�����ċA�I�ɓǂ݂Ȃ���A@ISA��ǂݎ��
sub isatable {
	my($startpkg, $pkg, $isa, $p2c) = @_;
	no strict 'refs';
	for my $name(keys %{$pkg.'::'}) {
		if( $name eq 'ISA' ) {
			my @isa = @{$pkg.'::'.$name};
			$isa->{$pkg} = \@isa if @isa;
			for my $parent(@isa) {
				next unless $parent =~ /^$startpkg\b/;
				push @{$p2c->{$parent}}, $pkg;
			}
		} elsif( $name =~ /::$/ ) {
			isatable($startpkg, $pkg.'::'.$`, $isa, $p2c);
		}
	}
}
