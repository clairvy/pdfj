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
	labeltext => Text('��', $s_smalltitle));
my $ps_30 = PStyle(size => $width, align => 'w', linefeed => 30,
	preskip => 7.5, postskip => 7.5);
my $ps_30dl = $ps_30->clone(labelsize => 25,
	labeltext => [\&numlabel, "%d.", $s_normal]);
#	labeltext => Text('��', $s_normal));
my $ps_30i = $ps_30->clone(beginindent => 40);
my $ps_30c1 = $ps_30->clone(size => 150);
my $ps_30c2 = $ps_30->clone(size => 500);
my $ps_30c2dl = $ps_30c2->clone(labelsize => 25,
	labeltext => Text('��', $s_normal));

my $sp_hr = Shape->style(SStyle(postskip => 5))->line(0,0,$width,0,
	SStyle(strokecolor => $c_cadetblue, linewidth => 2));

my $p1 = $doc->new_page;

Block('V', [
	Paragraph(
		Text('Perl�����ō����{��PDF', 
		$s_bigtitle), $ps_c40),
	Paragraph(
		Text('���{��g�Ń��[����g�ݍ���PDF�������W���[�� PDFJ', 
		$s_bigtitle), $ps_c40),
	Paragraph(
		Text('���� �� <nakajima@netstock.co.jp>', 
		$s_smalltitle), $ps_c30),
	Paragraph(
		Text('2002/5/11 Kansan.pm�Q���N�C�x���g', 
		$s_smalltitle), $ps_c30),
	Paragraph(
		Text('2002/10/18,2003/10/7,2005/2/17,3/13 ����', 
		$s_smalltitle), $ps_c30),
], $bs_topframe)->show($p1, 20, 20, 'bl');

my $p2 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('�w�i�ƖړI�`1'), '�w�i�ƖړI�`1'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('Web�A�v���P�[�V�����Ɉ���@�\���������邽�߂ɃT�[�o�[�œ��I�ɓ��{��PDF�𐶐�������', 
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
				Paragraph(Text('�T�[�o�[���ɂ�������̃\�t�g���C���X�g�[�����Ȃ��Ƃ����Ȃ�', $s_normal), $ps_30c2dl),
				Paragraph(Text('���G�Ȑ����������Ȃ炱�ꂵ���Ȃ����A�r�W�l�X�A�v���ɂ͕s�v���낤', $s_normal), $ps_30c2dl),
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
				Paragraph(Text('���{��Ή��ׂ̍��ȂƂ���܂ł͖���', $s_normal), $ps_30c2dl),
				Paragraph(Text('���p�̏ꍇ���C�Z���X���K�v', $s_normal), $ps_30c2dl),
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
				Paragraph(Text('���[��AJAVA�����c(^^;;;)', $s_normal), $ps_30c2dl),
				Paragraph(Text('XSL�͖��͂�����XSLT�������̂́c(^^;;;)', $s_normal), $ps_30c2dl),
				],
				$bs_td),
		],
	], $bs_table),
	Paragraph(
		Text('��Perl�����ł��傢���傢���Ƃ�肽���Ȃ�', $s_smalltitle), 
		$ps_35),
], $bs_frame)->show($p2, 20, 20, 'bl');

my $p3 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('�w�i�ƖړI�`2'), '�w�i�ƖړI�`2'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('�{�������̂�LaTeX�̃}�N���̑����Perl�X�N���v�g�Ń��C�A�E�g�ł����烉�N���Ȃ�', 
		$s_smalltitle), $ps_35),
	Paragraph(Text(['LaTeX�ŕ��G�ȃ}�N������������s����ō������c', Text('�i���݂܂���ATeXnician����Ȃ����̂Łj', $s_small)], $s_normal), $ps_30i),
	Paragraph(
		Text('���샂�W���[���Ȃ���{��g�Ń��[����������Ƒg�ݍ��߂邾�낤', 
		$s_smalltitle), $ps_35),
	Paragraph(Text(['TeX�ł͓���A���r�̔z�u�Ƃ��A�ǂ����݂̎��̋󔒂̋l�ߕ��Ƃ��c', Text('�i���݂܂���ATeXnician����Ȃ����̂Łj', $s_small)], $s_normal), $ps_30i),
], $bs_frame)->show($p3, 20, 20, 'bl');

my $p4 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('�ڕW'), '�ڕW'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('Perl�����ŏ����iC�̃R���p�C�����ł��Ȃ��T�[�o�[�ł��g����悤�Ɂj', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('���{��g�Ń��[���iJIS X 4051�j��g�ݍ���', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('�c������OK', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('�i���A�\�A�ӏ������A�}�Ƃ��������C�A�E�g�v�f�̃y�[�W�ւ̓K�؂Ȕz�u', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('�A�E�g���C����n�C�p�[�����N�Ƃ�����PDF�@�\�����p�ł���悤�ɂ���', 
		$s_smalltitle), $ps_35dl),
	Paragraph(
		Text('�ł������t���[�ɂ���', 
		$s_smalltitle), $ps_35dl),
], $bs_frame)->show($p4, 20, 20, 'bl');

my $p5 = $doc->new_page;
resetlabelnum();

Block('V', [
	Paragraph(
		Text([Outline('���{��g�Ń��[���`1'), '���{��g�Ń��[���`1'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('JIS X 4051�u���{�ꕶ���̍s�g�ŕ��@�v(1995)���̗p', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('JIS X 4051�̂������̂��̂��T�|�[�g', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('�񕨂̕��ƊԊu', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�֑������ƕ����֎~����', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�c����', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('���r', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�Y����', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('���_', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�����E�T��', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�s�������̂��߂̊Ԋu�������@', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�����̃n�C�t�l�[�V����', 
		$s_normal), $ps_30dl),
], $bs_frame)->show($p5, 20, 20, 'bl');

my $p6 = $doc->new_page;
resetlabelnum();

Block('V', [
	Paragraph(
		Text([Outline('���{��g�Ń��[���`2'), '���{��g�Ń��[���`2'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('JIS X 4051�ƈقȂ�_', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('�����Ԃ̊Ԋu�͂��ׂČ��̕����̃T�C�Y�ɏ]��', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�����X�y�[�X�͎O���󂫂łȂ��t�H���g�ɏ]��', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�����͖��T�|�[�g', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�^�u�����͖��T�|�[�g', 
		$s_normal), $ps_30dl),
], $bs_frame)->show($p6, 20, 20, 'bl');

my $p7 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('���͂͂ǂ�����H'), '���͂͂ǂ�����H'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('Perl�X�N���v�g�Œ��ڏ����͎̂��R�x�͍������ʓ|�B�Ȃ�炩�̃}�[�N�A�b�v�������͂Ƃ���PDF�𐶐�������', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('�Ǝ�����AXSL�ALaTeX�AHTML+CSS�ȂǁA���낢��l�����邪�c', 
		$s_normal), $ps_30),
	Paragraph(
		Text('XML�x�[�X�ɗ��������܂�����XPDFJ',
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('PDFJ�𒼐ڌĂԔ������b�p�[�{�}�N���@�\ ',
		$s_normal), $ps_30),
	Paragraph(
		Text('text2pdf��pod2pdf������܂��B��y�Ō��\�֗�',
		$s_smalltitle), $ps_35),
], $bs_frame)->show($p7, 20, 20, 'bl');

my $p8 = $doc->new_page;
resetlabelnum();

Block('V', [
	Paragraph(
		Text([Outline('����ƌv��'), '����ƌv��'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	Paragraph(
		Text('�ꉞ���p�ɂȂ郌�x���܂łł��Ă��܂���', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('��ȉۑ�', 
		$s_smalltitle), $ps_35),
	Paragraph(
		Text('XPDFJ���[�������Ė{����������Ă݂�',
		$s_normal), $ps_30dl),
	Paragraph(
		Text('PDF�̃t�H�[���A���߁A�d�q�����Ȃǂ̋@�\�ւ̑Ή�',
		$s_normal), $ps_30dl),
	Paragraph(
		Text('������PDF�̕ҏW�@�\ ',
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�`���[�g���A���I�Ȑ�����', 
		$s_normal), $ps_30dl),
	Paragraph(
		Text('�܂��܂��o�O������Ǝv���܂�', 
		$s_smalltitle), $ps_35),
], $bs_frame)->show($p8, 20, 20, 'bl');

my $p9 = $doc->new_page;

Block('V', [
	Paragraph(
		Text([Outline('�f��'), '�f��'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	10,
	Block('H', [
		Block('V', [
			Paragraph(
				Text("������������������������", $s_normal),
				$ps_50c),
			Paragraph(
				Text("�@�u�񕨂́A�i���ƊԊu�j�v", $s_normal),
				$ps_50c),
			Paragraph(
				Text([
					Text("�S�V�b�NGothic", TStyle(font => $f_gh)),
					" ",
					Text("����Minchou", TStyle(font => $f_mt)),
					" ",
					Text("�S�V�b�NHankaku", TStyle(font => $f_g)),
					" ",
					Text("����Hankaku", TStyle(font => $f_m)),
					" ",
					Text("�F����", TStyle(shapestyle => $ss_red)),
					" ",
					Text("����", TStyle(withline => 1)),
					" ",
					Text("���j��", 
						TStyle(withline => 1, withlinestyle => $ss_dash)),
					" ",
					Text("���_", TStyle(withdot => 1)),
					" ",
					Text("�Ԋ|��", TStyle(withbox => 'f', withboxstyle => 
						$ss_gray, shapestyle => $ss_white)),
					" ",
					Text("���{��Α�", TStyle(slant => 1)),
					" ",
					"�Y����", 
					Text("1�j", TStyle(suffix => 'u')),
					" ",
					Text("�����ʒu", TStyle(ruby => "��������")),
					" ",
					Text("�y", TStyle(ruby => "����")),
					"����",
					Text("�x��", TStyle(ruby => "�o�P�[�V����")),
					"�B",
					Text("��e��", TStyle(ruby => "�{�X")),
					" ",
					Text("��e��", TStyle(ruby => "boss")),
					" ",
					Text("fifteen", TStyle(ruby => "�t�B�t�e�B�[��")),
				], $s_normal),
				$ps_50c),
		], $bs_td),
		Block('R', [
			Paragraph(
				Text("������������������������", $s_normalv),
				$ps_50v),
			Paragraph(
				Text("�@�u�񕨂́A�i���ƊԊu�j�v", $s_normalv),
				$ps_50v),
			Paragraph(
				Text(
					[
					Text("�S�V�b�NGothic", TStyle(font => $f_ghv)),
					" ",
					Text("����Minchou", TStyle(font => $f_mtv)),
					" ",
					Text("�S�V�b�NHankaku", TStyle(font => $f_gv)),
					" ",
					Text("����Hankaku", TStyle(font => $f_mv)),
					" ",
					Text("�F����", TStyle(shapestyle => $ss_red)),
					" ",
					Text("�T��", TStyle(withline => 1)),
					" ",
					Text("�T�j��", 
						TStyle(withline => 1, withlinestyle => $ss_dash)),
					" ",
					Text("���_", TStyle(withdot => 1)),
					" ",
					Text("�Ԋ|��", TStyle(withbox => 'f', withboxstyle => 
						$ss_gray, shapestyle => $ss_white)),
					" ",
					Text("���{��Α�", TStyle(slant => 1)),
					" ",
					Text("(1)", TStyle(vh => 1)),
					"�c����",
					" ",
					"�Y��", 
					Text("��", TStyle(withnote => 
						Text(["�i",Text("1", TStyle(vh => 1)),"�j"], 
						TStyle(font => $f_ghv, fontsize => 12.5)))),
					" ",
					Text("�����ʒu", TStyle(ruby => "��������")),
					" ",
					Text("�y", TStyle(ruby => "����")),
					"����",
					Text("�x��", TStyle(ruby => "�o�P�[�V����")),
					"�B",
					Text("��e��", TStyle(ruby => "�{�X")),
					" ",
					Text("��e��", TStyle(ruby => "boss")),
					" ",
					Text("fifteen", TStyle(ruby => "�t�B�t�e�B�[��")),
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
	obj(Text("�`", TStyle(font => $f_m, fontsize => 21)), 2, 2, 'bl');

Block('V', [
	Paragraph(
		Text([Outline('�}�`�Ɖ摜�̃f��'), '�}�`�Ɖ摜�̃f��'], 
		$s_bigtitle), $ps_40),
	$sp_hr,
	10,
	Block('V', [
		Paragraph(
			Text([
				"�e�L�X�g���̉摜", 
				$img1, 
				"�A�e�L�X�g���̐}�`",
				Text($shp1, TStyle(objalign => 'm')),
				"�A�e�L�X�g���̐}�`���̃e�L�X�g",
				$shp2,
			], $s_normal),
			$ps_50c),
	], $bs_td),
], $bs_frame)->show($p10, 20, 20, 'bl');

$doc->print('demo.pdf');
