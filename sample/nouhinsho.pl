# nouhinsho.pl - PDFJ サンプルスクリプト - 納品書作成
# 2002 <nakajima@netstock.co.jp>
# perl nouhinsho.pl データファイル 出力ファイル
package Nouhinsho;
use PDFJ 'SJIS';
use strict;

# 各種のパラメーター
my @me = ( # 自社表示
	'（株）ネットストック', NewLine, 
	'東京都大田区蒲田XX-YYY', NewLine, 
	'03-XXXX-YYYY'
);
my @pagesize = (595, 842); # A4縦
my $bodypadding = 72; # ページ余白
my $bodywidth = $pagesize[0] - $bodypadding * 2; # 表示領域幅
my $bodyheight = $pagesize[1] - $bodypadding * 2; # 表示領域高さ
my %cellwidth;
$cellwidth{name} = 200; # 名称欄幅
$cellwidth{quantity} = 50; # 数量欄幅
$cellwidth{note} = $bodywidth - $cellwidth{name} - $cellwidth{quantity}; # 摘要欄幅
my $cellpadding = 5; # セル内余白
my $normalfontsize = 10; # フォントサイズ
my $bigfontsize = 15; # フォントサイズ大

# コンストラクタ
sub new {
	my($class) = @_;
	my $self = bless {}, $class;
	$self->initialize;
	$self;
}

# 初期化
# 文書オブジェクト、フォントオブジェクト、テキストスタイルを作成
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

# ヘッダ部で使われる段落を作成して返す
# headerpara(テキストスタイル名, 配置, preskip, postskip, 文字列リスト)
sub headerpara {
	my($self, $tstylename, $align, $preskip, $postskip, @str) = @_;
	Paragraph(Text(@str, $self->{tstyle}{$tstylename}),
		PStyle(size => $bodywidth, linefeed => '120%', align => $align,
			preskip => $preskip, postskip => $postskip));
}

# ヘッダブロックを作成
# makeheader(日付, 顧客名)
sub makeheader {
	my($self, $date, $customer) = @_;
	$self->{header} = Block('V',
		$self->headerpara('gothicbig', 'm', 20, 20, '納品書'),
		$self->headerpara('mincho', 'e', 5, 5, $date),
		$self->headerpara('gothicbig', 'b', 10, 10, 
			Text($customer, TStyle(withline => 1))),
		$self->headerpara('mincho', 'e', 5, 5, @me),
		BStyle());
}

# セルで使われる段落スタイルを作成して返す
# cellpstyle(セル名, 配置)
sub cellpstyle {
	my($self, $cellname, $align) = @_;
	PStyle(size => $cellwidth{$cellname} - $cellpadding * 2, linefeed => '120%',
		align => $align);
}

# セルブロックを作成して返す
# cellblock(テキストスタイル名, セル名, 配置, 文字列リスト)
sub cellblock {
	my($self, $tstylename, $cellname, $align, @str) = @_;
	my $withbox = $cellname eq 'quantity' ? 'lr' : '';
	Block('V', Paragraph(Text(@str, $self->{tstyle}{$tstylename}), 
		$self->cellpstyle($cellname, $align)),
		BStyle(padding => $cellpadding, withbox => $withbox, 
		withboxstyle => SStyle(linewidth => 0.5)));
}

# 表ブロックを作成
# maketable(データ配列参照)
# データ配列参照の要素は [名称, 数量, 摘要]
sub maketable {
	my($self, $dataarray) = @_;
	my @rows;
	# 見出し行
	push @rows, Block('H',
		$self->cellblock('gothic', 'name', 'm', '名称'),
		$self->cellblock('gothic', 'quantity', 'm', '数量'),
		$self->cellblock('gothic', 'note', 'm', '摘要'),
		BStyle(adjust => 1, postnobreak => 1, withbox => 'b', 
			withboxstyle => SStyle(linewidth => 0.5)));
	# データ行
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

# ヘッダブロックと表ブロックをページに配置する
sub makepage {
	my($self) = @_;
	my $doc = $self->{doc};
	# 一つのブロックにまとめた上で、
	my $pageblock = Block('V', $self->{header}, 20, $self->{table}, BStyle());
	# 表示領域の高さで分割し、
	my @blocks = $pageblock->break($bodyheight);
	# 各ブロックをページに配置
	my $pages = @blocks;
	for my $block(@blocks) {
		my $page = $doc->new_page;
		$block->show($page, $bodypadding, $bodypadding + $bodyheight, 'tl');
		# ページ上部にページ番号を表示
		my $header = $self->headerpara('mincho', 'e', 0, 0, 
			$page->pagenum . "/$pages ページ");
		$header->show($page, $bodypadding, $bodypadding + $bodyheight + 
			$bodypadding / 2, 'tl');
	}
}

# 出力
# print(ファイル名)
sub print {
	my($self, $file) = @_;
	$self->{doc}->print($file);
}

#-----------------------------------------------------------
package main;

my($datafile, $pdffile) = @ARGV;

# データファイルを読みとる
open D, $datafile or die;
# １行目：日付
my $date = <D>;
chomp $date;
# ２行目：顧客名
my $customer = <D>;
chomp $customer;
# ３行目以降：名称 タブ 数量 タブ 摘要
my @data;
while(<D>) {
	chomp;
	my($name, $quantity, $note) = split "\t";
	push @data, [$name, $quantity, $note];
}
close D;

# 納品書を作成
my $nouhinsho = new Nouhinsho;
$nouhinsho->makeheader($date, $customer);
$nouhinsho->maketable(\@data);
$nouhinsho->makepage;
$nouhinsho->print($pdffile);
