# pdfjclass.pl - PDFJツリーブロックサンプルスクリプト - PDFJクラス図
# 2005 <nakajima@netstock.co.jp>
use PDFJ;

# 次のuseは通常は必要ないが、シンボルテーブルからクラスツリーを作る必要上
use PDFJ::Matrix;
use PDFJ::Tree;
use PDFJ::Form;

use strict;

# パラメータ
my @Pagesize = (595, 842); # A4縦
my $Margin = 42; # 1.5cm
my $Fontsize = 10;
my $TitleFontsize = 14;
my @Color = qw(#FFDDEE #EEFFDD #DDEEFF #FFEEDD #EEDDFF #DDFFEE);
my $StartPKG = 'PDFJ'; # PDFJ::で始まるクラスを対象にする

# 文書オブジェクトとフォント
my $Doc = PDFJ::Doc->new(1.2, @Pagesize);
my $Font = $Doc->new_font('Ryumin-Light', '90ms-RKSJ-H', 'Times-Roman');

# 文書情報
$Doc->add_info(Title => 'PDFJ Tree Block demo', 
	Author => '<nakajima@netstock.co.jp>');

# ツリーデータを作成
my $tree = makeclasstree($StartPKG);

# 普通のツリースタイル
my $page1 = $Doc->new_page;
Block('V',
	# 表題
	Text('PDFJ Classes', TStyle(font => $Font, fontsize => $TitleFontsize)),
	Space(20),
	# ツリー（左が根）
	Block('TH', $tree, BStyle(adjust => 'l', 
		siblingalign => 'm', connectline => 'c', 
		levelskip => 20, siblingskip => 3)),
	BStyle())
	->show($page1, $Margin, $Pagesize[1] - $Margin, 'tl');

# 別のツリースタイル
my $page2 = $Doc->new_page;
Block('V',
	# 表題
	Text('PDFJ Classes (another style)', 
		TStyle(font => $Font, fontsize => $TitleFontsize)),
	Space(20),
	# ツリー（左が根）
	Block('TH', $tree, BStyle(adjust => 'ls', 
		levelskip => 5, siblingskip => 3)),
	BStyle())
	->show($page2, $Margin, $Pagesize[1] - $Margin, 'tl');

# 出力
$Doc->print('pdfjclass.pdf');

# 各クラス名を入れるブロック
sub classblock {
	my($classname, $color) = @_;
	my $text = Text($classname, TStyle(font => $Font, fontsize => $Fontsize));
	Block('V', 
		$text,
		BStyle(withbox => "sf", 
		withboxstyle => SStyle(fillcolor => Color($color)), padding => "3"));
}

# ツリーブロック用にクラスツリーを作成
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

# 再帰的にツリーを作成
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

# パッケージシンボルテーブルを再帰的に読みながら、@ISAを読み取る
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
