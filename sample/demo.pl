# PDFJ demo 
# 2002-5 Sey <nakajima@netstock.co.jp>
use PDFJ;
use strict;

my $doc = PDFJ::Doc->new(1.2, 792, 612);

$doc->add_info(Title => 'PDFJ demo', Author => '<nakajima@netstock.co.jp>');

my $f_h = $doc->new_font('Helvetica');
my $f_t = $doc->new_font('Times-Roman');
my $f_m = $doc->new_font('Ryumin-Light', '90ms-RKSJ-H');
my $f_mt = $doc->new_font('Ryumin-Light', '90ms-RKSJ-H', 'Times-Roman',
	'WinAnsiEncoding', 1.05);
my $f_g = $doc->new_font('GothicBBB-Medium', '90ms-RKSJ-H');
my $f_gh = $doc->new_font('GothicBBB-Medium', '90ms-RKSJ-H', 'Helvetica',
	'WinAnsiEncoding', 1.05);
my $f_mv = $doc->new_font('Ryumin-Light', '90ms-RKSJ-V');
my $f_mtv = $doc->new_font('Ryumin-Light', '90ms-RKSJ-V', 'Times-Roman',
	'WinAnsiEncoding', 1.05);
my $f_gv = $doc->new_font('GothicBBB-Medium', '90ms-RKSJ-V');
my $f_ghv = $doc->new_font('GothicBBB-Medium', '90ms-RKSJ-V', 'Helvetica',
	'WinAnsiEncoding', 1.05);

my $c_darkblue = Color('#191970');
my $c_cadetblue = Color('#5f9ea0');
my $c_lightcyan = Color('#e0ffff');
my $c_white = Color(1);
my $c_gray = Color(0.5);
my $c_red = Color(1,0,0);

my $ss_red = SStyle(fillcolor => $c_red);
my $ss_darkblue = SStyle(fillcolor => $c_darkblue);
my $ss_white = SStyle(fillcolor => $c_white);
my $ss_gray = SStyle(fillcolor => $c_gray);
my $ss_dash = SStyle(linedash => [2,2]);

my $s_bigtitle = TStyle(font => $f_gh, fontsize => 40, 
	shapestyle => $ss_darkblue);
my $s_smalltitle = TStyle(font => $f_gh, fontsize => 30, 
	shapestyle => $ss_darkblue);
my $s_normal = TStyle(font => $f_gh, fontsize => 25);
my $s_normalv = TStyle(font => $f_ghv, fontsize => 25);
my $s_small = TStyle(font => $f_gh, fontsize => 20);

my $width = 712;
my $padding = 20;

my $bs_topframe = 
	BStyle(padding => $padding, align => "mc", withbox => "sfr10", 
		height => 572,
		withboxstyle => 
		SStyle(linewidth => 5, strokecolor => $c_cadetblue, 
			fillcolor => $c_lightcyan));
my $bs_frame = 
	BStyle(padding => $padding, align => "tl", withbox => "sfr10", 
		height => 572,
		withboxstyle => 
		SStyle(linewidth => 5, strokecolor => $c_cadetblue, 
			fillcolor => $c_lightcyan));

my $bs_table = BStyle(adjust => 1);
my $bs_tr = BStyle(adjust => 1);
my $bs_td = BStyle(padding => 10, align => "tl", withbox => "sf", 
	withboxstyle => $ss_white);

my $LabelNum = 1;

sub resetlabelnum {
	$LabelNum = 1;
}

sub numlabel {
	my($fmt, $style) = @_;
	Text(sprintf($fmt, $LabelNum++), $style);
}

my $ps_c40 = PStyle(size => $width, align => 'm', linefeed => 40,
	preskip => 10, postskip => 10);
my $ps_c30 = PStyle(size => $width, align => 'm', linefeed => 30,
	preskip => 7.5, postskip => 7.5);
my $ps_50c = PStyle(size => 300, align => 'w', linefeed => 50,
	preskip => 12.5, postskip => 12.5);
my $ps_50v = PStyle(size => 400, align => 'w', linefeed => 50,
	preskip => 12.5, postskip => 12.5);
my $ps_40 = PStyle(size => $width, align => 'w', linefeed => 40,
	preskip => 10, postskip => 10);
my $ps_35 = PStyle(size => $width, align => 'w', linefeed => 35,
	preskip => 7.5, postskip => 7.5);
my $ps_35dl = $ps_35->clone(labelsize => 30, 
	labeltext => Text('＊', $s_smalltitle));
my $ps_30 = PStyle(size => $width, align => 'w', linefeed => 30,
	preskip => 7.5, postskip => 7.5);
my $ps_30dl = $ps_30->clone(labelsize => 25,
	labeltext => [\&numlabel, "%d.", $s_normal]);
#	labeltext => Text('＊', $s_normal));
my $ps_30i = $ps_30->clone(beginindent => 40);
my $ps_30c1 = $ps_30->clone(size => 150);
my $ps_30c2 = $ps_30->clone(size => 500);
my $ps_30c2dl = $ps_30c2->clone(labelsize => 25,
	labeltext => Text('＊', $s_normal));

my $sp_hr = Shape->style(SStyle(postskip => 5))->line(0,0,$width,0,
	SStyle(strokecolor => $c_cadetblue, linewidth => 2));

my $p1 = $doc->new_page;

Block('V', [
	Paragraph(
		Text('Perlだけで作る日本語PDF', 
		$s_bigtitle), $ps_c40),
	Paragraph(
		Text('日本語組版ルールを組み込んだPDF生成モジュール PDFJ', 
		$s_bigtitle), $ps_c40),
	Paragraph(
		Text('中島 靖 <nakajima@netstock.co.jp>', 
		$s_smalltitle), $ps_c30),
	Paragraph(
		Text('2002/5/11 Kansan.pm２周年イベント', 
		$s_smalltitle), $ps_c30),
	Paragraph(
		Text('2002/10/18,2003/10/7,2005/2/17,3/13 改訂', 
		$s_smalltitle), $ps_c30),
], $bs_topframe)->show($p1, 20, 20, 'bl');

my $p2 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('背景と目的～1'), '背景と目的～1'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('Webアプリケーションに印刷機能を持たせるためにサーバーで動的に日本語PDFを生成したい', 
		$s_smalltitle), $ps_35),
	Block('HV', [
		[
			Block('V',
				Paragraph(
					Text('TeX+dvipdfm', $s_normal),
					$ps_30c1),
				$bs_td),
			Block('V',
				[
				Paragraph(Text('サーバー側にたくさんのソフトをインストールしないといけない', $s_normal), $ps_30c2dl),
				Paragraph(Text('複雑な数式を扱うならこれしかないが、ビジネスアプリには不要だろう', $s_normal), $ps_30c2dl),
				],
				$bs_td),
		],
		[
			Block('V',
				Paragraph(
					Text('PDFLib', $s_normal),
					$ps_30c1),
				$bs_td),
			Block('V',
				[
				Paragraph(Text('日本語対応の細かなところまでは無理', $s_normal), $ps_30c2dl),
				Paragraph(Text('商用の場合ライセンスが必要', $s_normal), $ps_30c2dl),
				],
				$bs_td),
		],
		[
			Block('V',
				Paragraph(
					Text('FOP', $s_normal),
					$ps_30c1),
				$bs_td),
			Block('V',
				[
				Paragraph(Text('うーん、JAVAかぁ…(^^;;;)', $s_normal), $ps_30c2dl),
				Paragraph(Text('XSLは魅力だけどXSLTを書くのは…(^^;;;)', $s_normal), $ps_30c2dl),
				],
				$bs_td),
		],
	], $bs_table),
	Paragraph(
		Text('→Perlだけでちょいちょいっとやりたいなぁ', $s_smalltitle), 
		$ps_35),
], $bs_frame)->show($p2, 20, 20, 'bl');

my $p3 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('背景と目的～2'), '背景と目的～2'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('本を書くのにLaTeXのマクロの代わりにPerlスクリプトでレイアウトできたらラクだなぁ', 
		$s_smalltitle), $ps_35),
	Paragraph(Text(['LaTeXで複雑なマクロを書いたら不安定で困った…', Text('（すみません、TeXnicianじゃないもので）', $s_small)], $s_normal), $ps_30i),
	Paragraph(
		Text('自作モジュールなら日本語組版ルールもきちんと組み込めるだろう', 
		$s_smalltitle), $ps_35),
	Paragraph(Text(['TeXでは難しい、ルビの配置とか、追い込みの時の空白の詰め方とか…', Text('（すみません、TeXnicianじゃないもので）', $s_small)], $s_normal), $ps_30i),
], $bs_frame)->show($p3, 20, 20, 'bl');

my $p4 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('目標'), '目標'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('Perlだけで書く（Cのコンパイルができないサーバーでも使えるように）', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('日本語組版ルール（JIS X 4051）を組み込む', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('縦書きもOK', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('段落、表、箇条書き、図といったレイアウト要素のページへの適切な配置', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('アウトラインやハイパーリンクといったPDF機能も利用できるようにする', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('できる限りフリーにする', 
		$s_smalltitle), $ps_35dl),
], $bs_frame)->show($p4, 20, 20, 'bl');

my $p5 = $doc->new_page;
resetlabelnum();

Block('V', [
	Paragraph(
		Text([Outline('日本語組版ルール～1'), '日本語組版ルール～1'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('JIS X 4051「日本語文書の行組版方法」(1995)を採用', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('JIS X 4051のうち次のものをサポート', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('約物の幅と間隔', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('禁則処理と分離禁止処理', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('縦中横', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('ルビ', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('添え字', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('圏点', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('下線・傍線', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('行長揃えのための間隔調整方法', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('欧文のハイフネーション', 
		$s_normal), $ps_30dl),
], $bs_frame)->show($p5, 20, 20, 'bl');

my $p6 = $doc->new_page;
resetlabelnum();

Block('V', [
	Paragraph(
		Text([Outline('日本語組版ルール～2'), '日本語組版ルール～2'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('JIS X 4051と異なる点', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('文字間の間隔はすべて後ろの文字のサイズに従う', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('欧文スペースは三分空きでなくフォントに従う', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('割注は未サポート', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('タブ処理は未サポート', 
		$s_normal), $ps_30dl),
], $bs_frame)->show($p6, 20, 20, 'bl');

my $p7 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('入力はどうする？'), '入力はどうする？'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('Perlスクリプトで直接書くのは自由度は高いが面倒。なんらかのマークアップ言語を入力としてPDFを生成したい', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('独自言語、XSL、LaTeX、HTML+CSSなど、いろいろ考えられるが…', 
		$s_normal), $ps_30),
	Paragraph(
		Text('XMLベースに落ち着きました→XPDFJ',
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('PDFJを直接呼ぶ薄いラッパー＋マクロ機能 ',
		$s_normal), $ps_30),
	Paragraph(
		Text('text2pdfやpod2pdfもあります。手軽で結構便利',
		$s_smalltitle), $ps_35),
], $bs_frame)->show($p7, 20, 20, 'bl');

my $p8 = $doc->new_page;
resetlabelnum();

Block('V', [
	Paragraph(
		Text([Outline('現状と計画'), '現状と計画'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('一応実用になるレベルまでできてきました', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('主な課題', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('XPDFJを充実させて本を一冊書いてみる',
		$s_normal), $ps_30dl),
	Paragraph(
		Text('PDFのフォーム、注釈、電子署名などの機能への対応',
		$s_normal), $ps_30dl),
	Paragraph(
		Text('既存のPDFの編集機能 ',
		$s_normal), $ps_30dl),
	Paragraph(
		Text('チュートリアル的な説明書', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('まだまだバグがあると思います', 
		$s_smalltitle), $ps_35),
], $bs_frame)->show($p8, 20, 20, 'bl');

my $p9 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('デモ'), 'デモ'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	10,
	Block('H', [
		Block('V', [
			Paragraph(
				Text("□□□□□□□□□□□□", $s_normal),
				$ps_50c),
			Paragraph(
				Text("　「約物の、（幅と間隔）」", $s_normal),
				$ps_50c),
			Paragraph(
				Text([
					Text("ゴシックGothic", TStyle(font => $f_gh)),
					" ",
					Text("明朝Minchou", TStyle(font => $f_mt)),
					" ",
					Text("ゴシックHankaku", TStyle(font => $f_g)),
					" ",
					Text("明朝Hankaku", TStyle(font => $f_m)),
					" ",
					Text("色文字", TStyle(shapestyle => $ss_red)),
					" ",
					Text("下線", TStyle(withline => 1)),
					" ",
					Text("下破線", 
						TStyle(withline => 1, withlinestyle => $ss_dash)),
					" ",
					Text("圏点", TStyle(withdot => 1)),
					" ",
					Text("網掛け", TStyle(withbox => 'f', withboxstyle => 
						$ss_gray, shapestyle => $ss_white)),
					" ",
					Text("日本語斜体", TStyle(slant => 1)),
					" ",
					"添え字", 
					Text("1）", TStyle(suffix => 'u')),
					" ",
					Text("文字位置", TStyle(ruby => "もじいち")),
					" ",
					Text("楽", TStyle(ruby => "たの")),
					"しい",
					Text("休暇", TStyle(ruby => "バケーション")),
					"。",
					Text("大親分", TStyle(ruby => "ボス")),
					" ",
					Text("大親分", TStyle(ruby => "boss")),
					" ",
					Text("fifteen", TStyle(ruby => "フィフティーン")),
				], $s_normal),
				$ps_50c),
		], $bs_td),
		Block('R', [
			Paragraph(
				Text("□□□□□□□□□□□□", $s_normalv),
				$ps_50v),
			Paragraph(
				Text("　「約物の、（幅と間隔）」", $s_normalv),
				$ps_50v),
			Paragraph(
				Text(
					[
					Text("ゴシックGothic", TStyle(font => $f_ghv)),
					" ",
					Text("明朝Minchou", TStyle(font => $f_mtv)),
					" ",
					Text("ゴシックHankaku", TStyle(font => $f_gv)),
					" ",
					Text("明朝Hankaku", TStyle(font => $f_mv)),
					" ",
					Text("色文字", TStyle(shapestyle => $ss_red)),
					" ",
					Text("傍線", TStyle(withline => 1)),
					" ",
					Text("傍破線", 
						TStyle(withline => 1, withlinestyle => $ss_dash)),
					" ",
					Text("圏点", TStyle(withdot => 1)),
					" ",
					Text("網掛け", TStyle(withbox => 'f', withboxstyle => 
						$ss_gray, shapestyle => $ss_white)),
					" ",
					Text("日本語斜体", TStyle(slant => 1)),
					" ",
					Text("(1)", TStyle(vh => 1)),
					"縦中横",
					" ",
					"添え", 
					Text("字", TStyle(withnote => 
						Text(["（",Text("1", TStyle(vh => 1)),"）"], 
						TStyle(font => $f_ghv, fontsize => 12.5)))),
					" ",
					Text("文字位置", TStyle(ruby => "もじいち")),
					" ",
					Text("楽", TStyle(ruby => "たの")),
					"しい",
					Text("休暇", TStyle(ruby => "バケーション")),
					"。",
					Text("大親分", TStyle(ruby => "ボス")),
					" ",
					Text("大親分", TStyle(ruby => "boss")),
					" ",
					Text("fifteen", TStyle(ruby => "フィフティーン")),
					],
					$s_normalv),
				$ps_50v),
			], $bs_td),
	], $bs_tr),
], $bs_frame)->show($p9, 20, 20, 'bl');

my $p10 = $doc->new_page;

my $img1 = $doc->new_image('frame.jpg', 20, 20, 25, 25);
my $shp1 = Shape->ellipse(0,0,50,25,'sf',0,$ss_red);
my $shp2 = Shape($ss_red)->box(0,0,25,25,"sr4")->
	obj(Text("Ａ", TStyle(font => $f_m, fontsize => 21)), 2, 2, 'bl');

Block('V', [
	Paragraph(
		Text([Outline('図形と画像のデモ'), '図形と画像のデモ'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	10,
	Block('V', [
		Paragraph(
			Text([
				"テキスト中の画像", 
				$img1, 
				"、テキスト中の図形",
				Text($shp1, TStyle(objalign => 'm')),
				"、テキスト中の図形中のテキスト",
				$shp2,
			], $s_normal),
			$ps_50c),
	], $bs_td),
], $bs_frame)->show($p10, 20, 20, 'bl');

$doc->print('demo.pdf');
