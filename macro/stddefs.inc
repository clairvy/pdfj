<?xml version="1.0" encoding="x-sjis-cp932"?>
<!-- 
stddefs.inc : XPDFJの標準マクロ
2003-4 <nakajima@netstock.co.jp>
文書の先頭で、
 <do file="stddefs.inc" pagewidth="100" pageheight="200" margin="20"
 fontfiles="stdfontsV.inc, stdfontsH.inc"/>
のように呼び出す。（属性については下記参照）
Docオブジェクトはこのマクロの中で作成される。
-->
<do>

<!-- XPDFJのバージョンをチェック -->
<require XPDFJ="0.23"/>

<!-- 属性とデフォルト値にもとづいて%Docをセット -->
<eval>
	$Doc{Version} = $Args{version} || 1.3;
	$Doc{Pagewidth} = $Args{pagewidth} || 595;
	$Doc{Pageheight} = $Args{pageheight} || 842;
	$Doc{Leftmargin} = $Args{leftmargin} || $Args{margin} || 72;
	$Doc{Rightmargin} = $Args{rightmargin} || $Args{margin} || 72;
	$Doc{Topmargin} = $Args{topmargin} || $Args{margin} || 72;
	$Doc{Bottommargin} = $Args{bottommargin} || $Args{margin} || 72;
	$Doc{Fontsize} = $Args{fontsize} || 10;
	$Doc{Labelsize} = $Args{labelsize} || $Doc{Fontsize};
	$Doc{Termlabelsize} = $Args{termlabelsize} || $Doc{Fontsize} * 2;
	$Doc{Termlabelskip} = $Args{termlabelskip} || $Doc{Fontsize};
	$Doc{Linefeed} = $Args{linefeed} || '150%';
	
	$Doc{Bodywidth} = $Doc{Pagewidth} - $Doc{Leftmargin} - $Doc{Rightmargin};
	$Doc{Bodyleft} = $Doc{Leftmargin}; 
	$Doc{Bodyright} = $Doc{Pagewidth} - $Doc{Rightmargin}; 
	$Doc{Bodytop} = $Doc{Pageheight} - $Doc{Topmargin};
	$Doc{Bodyheight} = $Doc{Pageheight} - $Doc{Topmargin} - $Doc{Bottommargin};
</eval>

<!-- alignをb m eやl c rに変換するサブルーチン -->
<eval>
  sub align2bme {
    my($align, $default) = @_;
    $align =~ /^[bmewW]$/ ? $align :
    $align eq 'left' ? 'b' :
    $align eq 'center' ? 'm' :
    $align eq 'right' ? 'e' :
    $default;
  }
  sub align2lcr {
    my($align, $default) = @_;
    $align =~ /^[lcr]$/ ? $align :
    $align eq 'left' ? 'l' :
    $align eq 'center' ? 'c' :
    $align eq 'right' ? 'r' :
    $default;
  }
  sub align2tmb {
    my($align, $default) = @_;
    $align =~ /^[tmb]$/ ? $align :
    $align eq 'top' ? 't' :
    $align eq 'middle' ? 'm' :
    $align eq 'bottom' ? 'b' :
    $default;
  }
</eval>

<!-- レベル1のNewLineでテキストを分割するサブルーチン -->
<eval>
sub splitnl1 {
  my($texts) = @_;
  my @parts;
  my $current = [];
  for my $text(ref($texts) eq 'ARRAY' ? @$texts : ($texts)) {
    if( ref($text) eq 'PDFJ::NewLine' and $text-&gt;level == 1 ) {
      push @parts, $current;
      $current = [];
    } else {
      push @$current, $text;
    }
  }
  push @parts, $current;
  \@parts;
}
</eval>

<!-- Docオブジェクトの作成 -->
<Doc version="$Doc{Version}" pagewidth="$Doc{Pagewidth}" 
	pageheight="$Doc{Pageheight}"/>

<!-- fontfilesの指定にもとづいてフォント定義ファイルを読み込む -->
<eval>
	$Args{asize} ||= 1.05;
	$Args{fontfiles} ||= 'stdfontsH.inc';
	if( $Args{fontfiles} =~ /,/ ) {
		$Args{fontfiles} = [split(/\s*,\s*/, $Args{fontfiles})];
	}
</eval>
<for setvar="$_file" eval="$Args{fontfiles}">
  <do file="$_file"/>
</for>

<!-- 
  normalとdefaultのテキスト・段落スタイルを定義 
  defaultは<UL><OL><TD>などの中では変化する
-->
<TStyle setvar="$TStyle{normal}" font="$Font{default}" 
fontsize="$Doc{Fontsize}"/>
<PStyle setvar="$PStyle{normal}" size="$Doc{Bodywidth}" align="w" 
linefeed="$Doc{Linefeed}"/>
<eval>$TStyle{default} = $TStyle{normal}</eval>
<eval>$PStyle{default} = $PStyle{normal}</eval>

<!-- 以下、タグ定義 -->

<!--
  <CHAR>：Unicodeで文字を指定
  属性：code=文字コード（10進、0＋8進、0x＋16進）
-->
<def tag="CHAR">
  <eval>
    my $code = $Args{code} =~ /^0/ ? oct($Args{code}) : $Args{code} + 0;
    $Args{_char} = chr(int($code / 256)).chr($code % 256);
  </eval>
  <return>
    <Text texts="$Args{_char}"><style><TStyle code="UNICODE"/></style></Text>
  </return>
</def>

<!--
  <T>：テキストオブジェクトを返す
  属性：tstyle=テキストスタイルオブジェクトまたはスタイル文字列
  内容：テキスト（改行はNewLineに）
-->
<def tag="T" tstyle="">
  <do unless="$Args{tstyle}">
    <TStyle setvar="$Args{tstyle}"/>
  </do>
  <return>
    <Text style="$Args{tstyle}">
      <!--<texts><do withtext="autonl" contents="$Args{contents}"/></texts>-->
      <texts><do withtext="$Args{withtext}" contents="$Args{contents}"/></texts>
    </Text>
  </return>
</def>

<!--
  <S>：スタイルを指定してテキストオブジェクトを得る
  属性：テキストスタイルの属性をそのまま与える（例：italic="1" color="#ff0000"）
        colorはshapestyleのfillcolorとして扱われる
  内容：テキスト（改行はNewLineに）
-->
<def tag="S" attributesname="attr">
  <eval>
    if( $Args{attr}{color} ) {
      my $color = delete $Args{attr}{color};
      $Args{attr}{shapestyle} = {fillcolor => $color};
    }
  </eval>
  <return>
    <Text>
      <!--<texts><do withtext="autonl" contents="$Args{contents}"/></texts>-->
      <texts><do withtext="$Args{withtext}" contents="$Args{contents}"/></texts>
      <style><TStyle attributes="$Args{attr}"/></style>
    </Text>
  </return>
</def>

<!--
  <B>：太字
  内容：テキスト
-->
<alias tag="B" aliasof="S" bold="1"/>

<!--
  <I>：斜体
  内容：テキスト
-->
<alias tag="I" aliasof="S" italic="1"/>

<!--
  <U>：下線
  内容：テキスト
-->
<alias tag="U" aliasof="S" withline="1"/>

<!--
  <SUP>：上付き
  内容：テキスト
-->
<alias tag="SUP" aliasof="S" suffix="u"/>

<!--
  <SUB>：下付き
  内容：テキスト
-->
<alias tag="SUB" aliasof="S" suffix="l"/>

<!--
  <COMMA>：数字の並びに三桁ごとのカンマを入れる
  属性：なし
  内容：テキスト
-->
<def tag="COMMA">
  <do setvar="$num" withtext="text">$Args{contents}</do>
  <eval>while( $num =~ s/(\d)(\d\d\d)(?!\d)/$1,$2/g ) {}</eval>
  <return>
    <do withtext="text">$num</do>
  </return>
</def>

<!--
  <YEN>：整数値の場合のみ円マーク付きカンマ区切りの文字列にして返す
  属性：なし
  内容：テキスト
-->
<def tag="YEN">
  <do setvar="$num" withtext="text">$Args{contents}</do>
  <eval>
    if( $num =~ /^-?\d+$/ ) {
      while( $num =~ s/(\d)(\d\d\d)(?!\d)/$1,$2/g ) {}
      $num = "￥$num";
    }
  </eval>
  <return>
    <do withtext="text">$num</do>
  </return>
</def>

<!--
  下請け用タグ
  <_P>：指定のスタイルの段落を得る
  属性：pstyle=段落スタイル
        tstyle=テキストスタイル
        ※いずれも必須
        ※<P>と違い、デフォルトスタイルからのcloneはおこなわれない
  内容：テキスト（改行はNewLineに）
-->
<def tag="_P">
  <return>
    <Paragraph style="$Args{pstyle}">
      <text>
        <Text style="$Args{tstyle}">
          <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
        </Text>
      </text>
    </Paragraph>
  </return>
</def>

<!--
  下請け用タグ
  <_PL>：指定のスタイルのラベル付き段落を得る
  属性：pstyle=段落スタイル
        tstyle=テキストスタイル
        label=ラベルテキスト
        ※いずれも必須
        ※<P>と違い、デフォルトスタイルからのcloneはおこなわれない
  内容：テキスト（改行はNewLineに）
-->
<def tag="_PL">
  <eval>
    die "missing 'label' attribute" unless $Args{label};
  </eval>
  <clone setvar="$Args{_pstyle}" caller="$Args{pstyle}">
    <labeltext><Text texts="$Args{label}" style="$Args{tstyle}"/></labeltext>
  </clone>
  <return>
    <Paragraph style="$Args{_pstyle}">
      <text>
        <Text style="$Args{tstyle}">
          <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
        </Text>
      </text>
    </Paragraph>
  </return>
</def>

<!-- 属性の前処理用部品 -->

<def tag="_SetTstyleOverDefault" contentsmode="replace">
  <do if="$Args{tstyle}">
    <clone setvar="$Args{tstyle}" caller="$TStyle{default}" 
    style="$Args{tstyle}"/>
  </do>
  <eval>$Args{tstyle} ||= $TStyle{default}</eval>
</def>

<def tag="_SetFontToTstyle" contentsmode="replace">
  <do if="$Args{font}">
    <clone setvar="$Args{tstyle}" caller="$Args{tstyle}" font="$Args{font}"/>
  </do>
</def>

<def tag="_SetPstyleOverDefault" contentsmode="replace">
  <do if="$Args{pstyle}">
    <clone setvar="$Args{pstyle}" caller="$PStyle{default}" 
    style="$Args{pstyle}"/>
  </do>
  <eval>$Args{pstyle} ||= $PStyle{default}</eval>
</def>

<!--
  <P>：段落オブジェクトを返す
  属性：pstyle=段落スタイルオブジェクトまたはスタイル文字列
               $PStyle{default}をベースにcloneされる
               省略すると$PStyle{default}が使われる
        align=left、center、rightのいずれか。それぞれ段落スタイルのb、m、eに
              変換される
        tstyle=テキストスタイルオブジェクトまたはスタイル文字列
               （内容をテキストオブジェクト化するときに使われる）
               $TStyle{default}をベースにcloneされる
               省略すると$TStyle{default}が使われる
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        foreachline=真だと内容の各行をそれぞれ段落とする
  内容：テキスト（改行はNewLineに）
-->
<def tag="P" pstyle="" align="" tstyle="" font="" foreachline="0">
  <eval>
    if( $Args{align} ) {
      $Args{align} = align2bme($Args{align}, 'w');
    }
  </eval>
  <_SetTstyleOverDefault/>
  <_SetFontToTstyle/>
  <_SetPstyleOverDefault/>
  <do if="$Args{align}">
    <clone setvar="$Args{pstyle}" caller="$Args{pstyle}" align="$Args{align}"/>
  </do>
  <do if="$Args{foreachline}">
    <do setvar="$Args{_texts}" withtext="autonl:1" contents="$Args{contents}"/>
    <eval>$Args{_texts} = splitnl1($Args{_texts});</eval>
    <return>
      <for setvar="$Args{_text}" eval="$Args{_texts}">
        <Paragraph style="$Args{pstyle}">
          <text>
            <Text texts="$Args{_text}" style="$Args{tstyle}"/>
          </text>
        </Paragraph>
      </for>
    </return>
  </do>
  <do unless="$Args{foreachline}">
    <return>
      <Paragraph style="$Args{pstyle}">
        <text>
          <Text style="$Args{tstyle}">
            <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
          </Text>
        </text>
      </Paragraph>
    </return>
  </do>
</def>

<!--
  <UL>：箇条書き環境
  属性：pstyle=段落スタイルオブジェクトまたはスタイル文字列
               $PStyle{default}をベースにcloneされる
               省略すると$PStyle{default}が使われる
        label=ラベル文字列（省略すると「・」）
        labelsize=ラベルサイズ（省略すると$Doc{Labelsize}）
        indent=字下げ（省略すると箇条書きの入れ子に応じて自動で設定）
  内容：<LI>または<P>の並び
-->
<def tag="UL" label="・" labelsize="$Doc{Labelsize}" pstyle="" 
  indent="">
  <local setvar="$PStyle{default}"/>
  <eval>
    if( $Args{indent} ) {
      $Args{_beginpadding} = $Args{list_indent} = $Args{indent};
    } else {
      $Args{_beginpadding} = $Args{list_indent} + 0;
    }
    $Args{_indent} = $Args{list_indent} + $Args{labelsize};
    ++$List{level};
    $List{counter}[$List{level}] = $Args{label};
  </eval>
  <_SetPstyleOverDefault/>
  <clone setvar="$PStyle{default}" caller="$Args{pstyle}" 
  beginpadding="$Args{_indent}"/>
  <clone setvar="$Args{_pstyle}" caller="$Args{pstyle}" 
  labelsize="$Args{labelsize}" labeltext="$Args{label}" 
  beginpadding="$Args{_beginpadding}"/>
  <return>
    <do list_indent="$Args{_indent}" list_pstyle="$Args{_pstyle}" contents="$Args{contents}"/>
  </return>
  <eval>--$List{level}</eval>
</def>

<!--
  <OL>：番号付き箇条書き環境
  属性：pstyle=段落スタイルオブジェクトまたはスタイル文字列
               $PStyle{default}をベースにcloneされる
               省略すると$PStyle{default}が使われる
        label=ラベル初期値（省略すると1）
              ※今のところ、指定できるのは半角の英数字のみ
              ※「-」を指定すると初期化せずに前回のOLのラベルを引き継ぐ
        prelabel=ラベルの前置文字列
        postlabel=ラベルの後置文字列（省略すると「.」）
        labelsize=ラベルサイズ（省略すると$Doc{Labelsize}）
        indent=字下げ（省略すると箇条書きの入れ子に応じて自動で設定）
  内容：<LI>または<P>の並び
-->
<def tag="OL" label="1" prelabel="" postlabel="." labelsize="$Doc{Labelsize}" 
  pstyle="" indent="">
  <local setvar="$PStyle{default}"/>
  <eval>
    ++$List{level};
    $List{counter}[$List{level}] = $Args{label} unless $Args{label} eq '-';
    $List{counter}[$List{level}] = 1 unless defined $List{counter}[$List{level}];
    if( $Args{indent} ) {
      $Args{_beginpadding} = $Args{list_indent} = $Args{indent};
    } else {
      $Args{_beginpadding} = $Args{list_indent} + 0;
    }
    $Args{_indent} = $Args{list_indent} + $Args{labelsize};
  </eval>
  <_SetPstyleOverDefault/>
  <clone setvar="$PStyle{default}" caller="$Args{pstyle}" 
  beginpadding="$Args{_indent}"/>
  <clone setvar="$Args{_pstyle}" caller="$Args{pstyle}" 
  labelsize="$Args{labelsize}" beginpadding="$Args{_beginpadding}"/>
  <return>
    <do list_indent="$Args{_indent}" list_pstyle="$Args{_pstyle}" 
    list_prelabel="$Args{prelabel}" 
    list_postlabel="$Args{postlabel}" contents="$Args{contents}"/>
  </return>
  <eval>
    --$List{level};
  </eval>
</def>

<!--
  <LI>：箇条書き段落
  属性：tstyle=テキストスタイルオブジェクトまたはスタイル文字列
               $TStyle{default}をベースにcloneされる
               省略すると$TStyle{default}が使われる
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        foreachline=真だと内容の各行をそれぞれ箇条書き段落とする
  内容：テキスト（改行はNewLineに）
-->
<def tag="LI" tstyle="" font="" foreachline="0">
  <_SetTstyleOverDefault/>
  <_SetFontToTstyle/>
  <eval>$Args{_pstyle} = $Args{list_pstyle}</eval>
  <do if="$Args{foreachline}">
    <do setvar="$Args{_texts}" withtext="autonl:1" contents="$Args{contents}"/>
    <eval>$Args{_texts} = splitnl1($Args{_texts});</eval>
    <return>
      <for setvar="$Args{_text}" eval="$Args{_texts}">
        <do if="$List{counter}[$List{level}] =~ /^[0-9a-zA-Z]+$/" result="null">
          <eval>$Args{_label} = $Args{list_prelabel}.$List{counter}[$List{level}]++.$Args{list_postlabel};</eval>
          <clone setvar="$Args{_pstyle}" caller="$Args{_pstyle}" labeltext="$Args{_label}"/>
        </do>
        <Paragraph style="$Args{_pstyle}">
          <text><Text texts="$Args{_text}" style="$Args{tstyle}"/></text>
        </Paragraph>
      </for>
    </return>
  </do>
  <do unless="$Args{foreachline}">
    <do if="$List{counter}[$List{level}] =~ /^[0-9a-zA-Z]+$/">
      <eval>$Args{_label} = $Args{list_prelabel}.$List{counter}[$List{level}]++.
        $Args{list_postlabel};</eval>
      <clone setvar="$Args{_pstyle}" caller="$Args{_pstyle}" labeltext="$Args{_label}"/>
    </do>
    <return>
      <Paragraph style="$Args{_pstyle}">
        <text>
          <Text style="$Args{tstyle}">
            <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
          </Text>
        </text>
      </Paragraph>
    </return>
  </do>
</def>

<!--
  <MLI>：内容の各行を<LI>段落とする
-->
<alias tag="MLI" aliasof="LI" foreachline="1"/>

<!--
  <DL>：語句説明箇条書き環境
  属性：pstyle=段落スタイルオブジェクトまたはスタイル文字列
               $PStyle{default}をベースにcloneされる
               省略すると$PStyle{default}が使われる
        labelsize=ラベルサイズ（省略すると$Doc{Termlabelsize}）
        labelskip=ラベルと本文の間隔（省略すると$Doc{Termlabelskip}）
        indent=字下げ（省略すると箇条書きの入れ子に応じて自動で設定）
  内容：<DT>または<DD>の並び
-->
<def tag="DL" labelsize="$Doc{Termlabelsize}" labelskip="$Doc{Termlabelskip}"
  pstyle="" indent="">
  <local setvar="$PStyle{default}"/>
  <eval>
    ++$List{level};
    if( $Args{indent} ) {
      $Args{_beginpadding} = $Args{list_indent} = $Args{indent};
    } else {
      $Args{_beginpadding} = $Args{list_indent} + 0;
    }
    $Args{_indent} = $Args{list_indent} + $Args{labelsize};
  </eval>
  <_SetPstyleOverDefault/>
  <clone setvar="$PStyle{default}" caller="$Args{pstyle}" 
  beginpadding="$Args{_indent}"/>
  <clone setvar="$Args{_pstyle}" caller="$Args{pstyle}" 
  labelsize="$Args{labelsize}" labelskip="$Args{labelskip}" 
  beginpadding="$Args{_beginpadding}"/>
  <return>
    <do list_indent="$Args{_indent}" list_pstyle="$Args{_pstyle}" contents="$Args{contents}"/>
  </return>
  <eval>
    --$List{level};
  </eval>
</def>

<def tag="DT">
  <eval>$Args{_pstyle} = $Args{list_pstyle}</eval>
  <do setvar="$Args{_term}" withtext="text">$Args{contents}</do>
  <eval>
    $List{dt}[$List{level}] = $Args{_term}
  </eval>
</def>

<def tag="DD" tstyle="" font="">
  <eval>
    $Args{_pstyle} = $Args{list_pstyle};
    $Args{_term} = $List{dt}[$List{level}];
  </eval>
  <_SetTstyleOverDefault/>
  <_SetFontToTstyle/>
  <clone setvar="$Args{_tstyle}" caller="$Args{tstyle}" bold="1"/>
  <clone setvar="$Args{_pstyle}" caller="$Args{_pstyle}">
    <labeltext>
      <Text texts="$Args{_term}" style="$Args{_tstyle}"/>
    </labeltext>
  </clone>
  <return>
    <Paragraph style="$Args{_pstyle}">
      <text>
        <Text style="$Args{tstyle}">
          <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
        </Text>
      </text>
    </Paragraph>
  </return>
  <eval>
    $List{dt}[$List{level}] = '';
  </eval>
</def>

<!--
  <HR>：横線のみを含むブロックオブジェクトを返す
  属性：width=横幅（省略すると「100%」）
              （%指定すると現在の$PStyle{default}{size}に対する割合）
        size=線幅（省略すると0.25）
        color=色（省略すると黒）
        align=left、center、rightのいずれか（省略するとcenter）
        preskip=前間隔（省略すると0）
        postskip=後間隔（省略すると0）
  内容：なし
-->
<def tag="HR" width="100%" size="0.25" color="0" align="center" preskip="0" 
postskip="0">
  <eval>
    $Args{_fullwidth} = $PStyle{default}{size};
    $Args{_width} = $Args{width} =~ /^\d+%$/ ? 
      $Args{width} * $Args{_fullwidth} / 100 :
      $Args{width};
    $Args{align} = align2lcr($Args{align}, 'c');
  </eval>
  <return>
  <Block direction="V">
    <style><BStyle width="$Args{_fullwidth}" align="$Args{align}" 
    preskip="$Args{preskip}" postskip="$Args{postskip}"/></style>
    <objects>
      <Shape>
        <call>
          <line x="0" y="0" w="$Args{_width}" h="0">
            <style>
              <SStyle linewidth="$Args{size}">
                <strokecolor><Color value="$Args{color}"/></strokecolor>
              </SStyle>
            </style>
          </line>
        </call>
      </Shape>
    </objects>
  </Block>
  </return>
</def>

<!-- <TABLE><TR><TD>の共通部品 -->

<def tag="_SetPstyleTstyleFontToDefault" contentsmode="replace">
  <do if="$Args{pstyle}">
    <clone setvar="$PStyle{default}" caller="$PStyle{default}" 
      style="$Args{pstyle}"/>
  </do>
  <do if="$Args{tstyle}">
    <clone setvar="$TStyle{default}" caller="$TStyle{default}" 
      style="$Args{tstyle}"/>
  </do>
  <do if="$Args{font}">
    <clone setvar="$TStyle{default}" caller="$TStyle{default}" 
      font="$Args{font}"/>
  </do>
</def>

<!--
  <TABLE>：表のブロックオブジェクトを返す
  属性：cellwidth=セル幅（省略すると「200」）
            （カンマ区切りで各セルの幅を指定。セル数のほうが多いと最後の値が
            繰り返し使われる。%指定すると現在の$PStyle{default}{size}に対する
            割合）
        cellpadding=セル内余白
        cellbox=セルボックス（PDFJのboxのspec指定）
            （カンマ区切りで各セルに指定。セル数のほうが多いと最後の値が
            繰り返し使われる。）
        cellboxstyle=セルボックススタイル（PDFJのboxのstyle指定）
            （省略すると「linewidth: 0.25」）
        tablebox=表ボックス（PDFJのboxのspec指定）
        tableboxstyle=表ボックススタイル（PDFJのboxのstyle指定）
            （省略すると「linewidth: 0.25」）
        indent=行頭側に取られる間隔
        pstyle=段落スタイル（内部のTDに効果を及ぼす）
        tstyle=テキストスタイル（内部のTDに効果を及ぼす）
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        align=横配置 left,center,right
        valign=縦配置 top,middle,bottom
            （alignとvalignはカンマ区切りで各セルの配置を指定。セル数のほうが
            多いと最後の値が繰り返し使われる。）
        preskip=前間隔
        postskip=後間隔
        postnobreak=真で、後ろで改ページしない
        nobreak=真で、途中で改ページしない
  内容：<TR>の並び
  ※今のところ、横書きにのみ対応
-->
<def tag="TABLE" direction="HV" cellwidth="200" cellpadding="0" cellbox="" 
cellboxstyle="linewidth: 0.25" tablebox="" tableboxstyle="linewidth: 0.25"
indent="0" preskip="0" postskip="0" postnobreak="0" nobreak="0" pstyle="" 
tstyle="" font="" align="left" valign="top">
  <local setvar="$PStyle{default}"/>
  <local setvar="$TStyle{default}"/>
  <eval>
    ++$Table{level};
    $Table{rowspans}[$Table{level}] = [];
    $Args{_fullwidth} = $PStyle{default}{size};
    $Args{_cellwidth} = [split(/\s*,\s*/, $Args{cellwidth})];
    grep {$_ = $Args{_fullwidth} * $_ / 100 if /^\d+%$/} @{$Args{_cellwidth}};
  </eval>
  <_SetPstyleTstyleFontToDefault/>
  <return>
  <Block direction="$Args{direction}">
    <style><BStyle withbox="$Args{tablebox}" withboxstyle="$Args{tableboxstyle}" 
      blockalign="$Args{indent}" preskip="$Args{preskip}" 
      postskip="$Args{postskip}" postnobreak="$Args{postnobreak}" 
      nobreak="$Args{nobreak}" adjust="1"/></style>
    <objects>
      <do contents="$Args{contents}"
      cellwidth="$Args{_cellwidth}" cellpadding="$Args{cellpadding}" 
      cellbox="$Args{cellbox}" cellboxstyle="$Args{cellboxstyle}" 
      align="$Args{align}" valign="$Args{valign}"/>
    </objects>
  </Block>
  </return>
  <eval>--$Table{level}</eval>
</def>

<!--
  <TR>：表の行のブロックオブジェクトを返す
  属性：cellpadding=セル内余白
        cellbox=セルボックス（PDFJのboxのspec指定）
            （カンマ区切りで各セルに指定。セル数のほうが多いと最後の値が
            繰り返し使われる。）
        cellboxstyle=セルボックススタイル（PDFJのboxのstyle指定）
        align=横配置 left,center,right
        valign=縦配置 top,middle,bottom
            （カンマ区切りで各セルの配置を指定。セル数のほうが多いと最後の値が
            繰り返し使われる。）
        pstyle=段落スタイル（内部のTDに効果を及ぼす）
        tstyle=テキストスタイル（内部のTDに効果を及ぼす）
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        ※いずれも省略すると<TABLE>で指定した値
        postnobreak=この行の後でページ分割しない
  内容：<TD>の並び
-->
<def tag="TR" postnobreak="0">
  <local setvar="$PStyle{default}"/>
  <local setvar="$TStyle{default}"/>
  <eval>
    my $rs = $Table{rowspans}[$Table{level}];
    grep {--$_ if $_ > 0} @$rs;
    $Table{colnum}[$Table{level}] = 0;
    $Args{cellbox} = [split(/\s*,\s*/, $Args{cellbox})];
    $Args{_align} = ref($Args{align}) eq 'ARRAY' ?
      $Args{align} : [split(/\s*,\s*/, $Args{align})];
    $Args{_valign} = ref($Args{valign}) eq 'ARRAY' ?
      $Args{valign} : [split(/\s*,\s*/, $Args{valign})];
  </eval>
  <_SetPstyleTstyleFontToDefault/>
  <return arrayref="1">
    <do contents="$Args{contents}"
      cellpadding="$Args{cellpadding}" cellbox="$Args{cellbox}" 
      cellboxstyle="$Args{cellboxstyle}" align="$Args{_align}"
      valign="$Args{_valign}"
      postnobreak="$Args{postnobreak}"/>
  </return>
</def>

<!--
  <TD>：表のセルのブロックオブジェクトを返す
  属性：cellpadding=セル内余白
        cellbox=セルボックス（PDFJのboxのspec指定）
        cellboxstyle=セルボックススタイル（PDFJのboxのstyle指定）
        align=横配置 left,center,right
        valign=縦配置 top,middle,bottom
        ※省略すると<TABLE>あるいは<TR>で指定した値
        pstyle=段落スタイル（$PStyle{default}にcloneされる）
        tstyle=テキストスタイル（$TStyle{default}にcloneされる）
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        colspan=まとめる列数
  内容：テキストまたはオブジェクトの並び
        （テキストの場合は段落オブジェクト化される）
-->
<def tag="TD">
  <local setvar="$PStyle{default}"/>
  <local setvar="$TStyle{default}"/>
  <eval>
    my $rs = $Table{rowspans}[$Table{level}];
    my $j = $Table{colnum}[$Table{level}];
    while( $rs->[$j] > 0 ) {
      $j++;
    }
    $Args{_width} = $Args{cellwidth}->[$j >= @{$Args{cellwidth}} ? 
      $#{$Args{cellwidth}} : $j];
    $Args{colspan} ||= 1;
    $Args{rowspan} ||= 1;
    $rs->[$j] = $Args{rowspan};
    for( my $k = 1; $k &lt; $Args{colspan}; $k++ ) {
      $Args{_width} += $Args{cellwidth}->[$j+$k >= @{$Args{cellwidth}} ? 
        $#{$Args{cellwidth}} : $j+$k];
    }
    $Args{_size} = $Args{_width} - $Args{cellpadding} * 2;
    if( ref($Args{align}) eq 'ARRAY' ) {
      $Args{align} = $Args{align}->[$j >= @{$Args{align}} ?
        $#{$Args{align}} : $j];
    }
    if( ref($Args{valign}) eq 'ARRAY' ) {
      $Args{valign} = $Args{valign}->[$j >= @{$Args{valign}} ?
        $#{$Args{valign}} : $j];
    }
    $Args{palign} = align2bme($Args{align}, 'w');
    $Args{balign} = align2lcr($Args{align}, 'l');
    $Args{balign} .= align2tmb($Args{valign}, 't');
    if( ref($Args{cellbox}) eq 'ARRAY' ) {
      $Args{cellbox} = @{$Args{cellbox}} ?
        $Args{cellbox}->[$j >= @{$Args{cellbox}} ?
        $#{$Args{cellbox}} : $j] : "";
    }
  </eval>
  <clone setvar="$PStyle{default}" caller="$PStyle{default}" 
    size="$Args{_size}" align="$Args{palign}"/>
  <_SetPstyleTstyleFontToDefault/>
  <BStyle setvar="$Args{_style}" width="$Args{_width}" 
    padding="$Args{cellpadding}" withbox="$Args{cellbox}" 
    withboxstyle="$Args{cellboxstyle}" align="$Args{balign}"
    postnobreak="$Args{postnobreak}" colspan="$Args{colspan}"
    rowspan="$Args{rowspan}"/>
  <do setvar="$Args{_coocked}" withtext="autonl" contents="$Args{contents}"/>
  <eval>@{$Args{_types}} = type($Args{_coocked})</eval>
  <do if="$Args{_types}[0] eq 'text' || $Args{_types}[0] eq 'Text' || $Args{_types}[0] eq 'Dest'">
    <Paragraph setvar="$Args{_coocked}" style="$PStyle{default}"><text>
      <Text style="$TStyle{default}"><texts>$Args{_coocked}</texts></Text>
    </text></Paragraph>
  </do>
  <return>
    <Block direction="V" style="$Args{_style}">
      <objects>$Args{_coocked}</objects> 
    </Block>
  </return>
  <eval>
    $Table{colnum}[$Table{level}] += $Args{colspan} ? $Args{colspan} : 1;
  </eval>
</def>

<!--
  <TH>：<TD align="center" tstyle="bold:1">
-->
<alias tag="TH" aliasof="TD" align="center" tstyle="bold:1"/>

<!--
  <IMG>：画像
  属性：src=ファイル名またはURL
        pxwidth=横ピクセルサイズ
        pxheight=縦ピクセルサイズ
        width=表示横サイズ（ポイント）
        height=表示縦サイズ（ポイント）
        padding=周囲余白
        colorspace=rgb,cmyk,grayのいずれか（省略するとrgb）
  内容：属性として解釈
-->
<def tag="IMG" contentsmode="arg" attributesname="attr">
  <return>
    <new_image caller="$Doc" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <BR>：<NewLine>
-->
<alias tag="BR" aliasof="NewLine"/>

<!--
  <NEWPAGE>：<NewBlock>
-->
<alias tag="NEWPAGE" aliasof="NewBlock"/>

<!--
  <SKIP>：<BlockSkip>
  属性：skip=間隔
-->
<alias tag="SKIP" aliasof="BlockSkip"/>

<!--
  <DIV>：ブロックを作る
  属性：align=横書きならleft,center,right、縦書きならtop,middle,bottomのいずれか。
              それぞれブロックスタイルのl,c,r、t,m,bに変換される
        その他の属性はそのままブロックスタイルになる
        ※preskipとpostskipは省略すると'c'になる（先頭/末尾要素のものを使う）
  内容：ブロックの内容になる
-->
<def tag="DIV" attributesname="attr">
  <local setvar="$PStyle{default}"/>
  <eval>
    $Args{preskip} = 'c' if $Args{preskip} eq '';
    $Args{postskip} = 'c' if $Args{postskip} eq '';
    $Args{_bdir} = delete $Args{attr}{direction};
    $Args{_bdir} ||= ($Doc{Fontdirection} eq 'H' ? 'V' : 'R');
    $Args{attr}{align} = $Args{_bdir} eq 'V' ?
      align2lcr($Args{attr}{align}, 'l') : align2tmb($Args{attr}{align}, 't');
    my $size = $PStyle{default}{size} - $Args{attr}{blockalign}
      - $Args{attr}{padding} * 2;
    if( $Args{_bdir} eq 'V' ) {
      $Args{attr}{width} ||= $size;
    } else {
      $Args{attr}{height} ||= $size;
    }
    $Args{_width} = $Args{_bdir} eq 'V' ? 
      $Args{attr}{width} : $Args{attr}{height};
  </eval>
  <clone setvar="$PStyle{default}" caller="$PStyle{default}" size="$Args{_width}"/>
  <return>
    <Block direction="$Args{_bdir}">
      <style><BStyle attributes="$Args{attr}"/></style>
      <objects><do contents="$Args{contents}"/></objects>
    </Block>
  </return>
</def>

<!--
  <HXNUMBER>：H1～4に対する自動番号付けの指定
  属性：level=対象のHxの番号
        number=番号文字列（{Hx}が何番目のHxかを表す）
        ※HXNUMBERを指定してもH1～4でnonumber="1"なら自動番号付けしない
  内容：属性として解釈
-->
<def tag="HXNUMBER" contentsmode="arg">
  <eval>
    $Doc{HXNUMBERSTR}{"H$Args{level}"} = $Args{number};
  </eval>
</def>

<!--
  <HXOUTLINE>：H1～4のうちどれをアウトライン（しおり）にするかの指定
  属性：level=アウトラインにする番号をカンマ区切りで（省略すると2,3）
        ※HXOUTLINEで指定してもH1～4でnooutline="1"ならアウトラインにしない
  内容：属性として解釈
-->
<def tag="HXOUTLINE" contentsmode="arg" level="2,3">
  <eval>
    %HxOutline = ();
    my @levels = split /\s*,\s*/, $Args{level};
    for( my $j = 0; $j &lt; @levels; $j++ ) {
      $HxOutline{"H$levels[$j]"} = $j;
    }
  </eval>
</def>

<!--
  <Hx>：見出し
  属性：nooutline=真:アウトラインにしない
        nonumber=真：HXNUMBERが指定されていても自動番号付しない（カウントもしない）
        pstyle=段落スタイル（$PStyle{Hx}にcloneされる）
        tstyle=テキストスタイル（$TStyle{Hx}にcloneされる）
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        alt=マクロ名（このマクロを呼び出した結果を見出しとする）
        header=ヘッダ文字列（一時変更）
        headerall=ヘッダ文字列（以降の全ページ）
        headereven=ヘッダ文字列（以降の偶数ページ）
        headerodd=ヘッダ文字列（以降の奇数ページ）
        footer=フッタ文字列（一時変更）
        footerall=フッタ文字列（以降の全ページ）
        footereven=フッタ文字列（以降の偶数ページ）
        footerodd=フッタ文字列（以降の奇数ページ）
        ※header*やfooter*に'*'を指定すると内容のテキストと同じ
        ※pstyle,tstyle,fontを省略すると、$PStyle{Hx},$TStyle{Hx}が使われる
        ※内容が空の場合、指定したpstyle,tstyle,fontをcloneした結果が$PStyle{Hx},$TStyle{Hx}にセットされる
        ※altで指定したマクロには、text属性を通じて見出しのテキストオブジェクト（アウトラインと番号付けの処理済み）が渡される
        ※altを指定して内容が空の場合、altの値が保存されて、以後はそれが使われる
  内容：テキスト
-->
<eval>
  $PStyleHash{H1} = {typename => 'xH', align => 'm', postnobreak => 1,
    preskip => $Doc{Fontsize} * 4.75, 
    postskip => {default => $Doc{Fontsize} * 3.25, xH => 0} };
  $TStyleHash{H1} = {bold => '1', fontsize => $Doc{Fontsize} * 1.6};
  
  $PStyleHash{H2} = {typename => 'xH', align => 'b', postnobreak => 1,
    preskip => $Doc{Fontsize} * 3.25, 
    postskip => {default => $Doc{Fontsize} * 2.25, xH => 0} };
  $TStyleHash{H2} = {bold => '1', fontsize => $Doc{Fontsize} * 1.4};
  
  $PStyleHash{H3} = {typename => 'xH', align => 'b', postnobreak => 1,
    preskip => $Doc{Fontsize} * 2.25, 
    postskip => {default => $Doc{Fontsize} * 1.75, xH => 0} };
  $TStyleHash{H3} = {bold => '1', fontsize => $Doc{Fontsize} * 1.2};
  
  $PStyleHash{H4} = {typename => 'xH', align => 'b', postnobreak => 1,
    preskip => $Doc{Fontsize} * 1.75,
    postskip => {default => $Doc{Fontsize} * 0.75, xH => 0} };
  $TStyleHash{H4} = {bold => '1', fontsize => $Doc{Fontsize} * 1.1};
</eval>
<PStyle setvar="$PStyle{H1}" style="$PStyleHash{H1}"/>
<TStyle setvar="$TStyle{H1}" style="$TStyleHash{H1}"/>
<PStyle setvar="$PStyle{H2}" style="$PStyleHash{H2}"/>
<TStyle setvar="$TStyle{H2}" style="$TStyleHash{H2}"/>
<PStyle setvar="$PStyle{H3}" style="$PStyleHash{H3}"/>
<TStyle setvar="$TStyle{H3}" style="$TStyleHash{H3}"/>
<PStyle setvar="$PStyle{H4}" style="$PStyleHash{H4}"/>
<TStyle setvar="$TStyle{H4}" style="$TStyleHash{H4}"/>
<alias tag="H1" aliasof="_HX" name="H1"/>
<alias tag="H2" aliasof="_HX" name="H2"/>
<alias tag="H3" aliasof="_HX" name="H3"/>
<alias tag="H4" aliasof="_HX" name="H4"/>
<def tag="_HX">
  <do setvar="$Args{_text}" withtext="text" contents="$Args{contents}"/>
  <eval>
    $Args{_pstyle} = $PStyle{$Args{name}};
    $Args{_tstyle} = $TStyle{$Args{name}};
    $Args{_alt} = $Args{alt} || $HxAlt{$Args{name}};
  </eval>
  <do if="$Args{pstyle}">
    <clone setvar="$Args{_pstyle}" caller="$Args{_pstyle}" 
      style="$Args{pstyle}"/>
  </do>
  <do if="$Args{tstyle}">
    <clone setvar="$Args{_tstyle}" caller="$Args{_tstyle}" 
      style="$Args{tstyle}"/>
  </do>
  <do if="$Args{font}">
    <clone setvar="$Args{_tstyle}" caller="$Args{_tstyle}" 
      font="$Args{font}"/>
  </do>
  <eval>
    if( $Args{_text} eq '' ) {
      $PStyle{$Args{name}} = $Args{_pstyle};
      $TStyle{$Args{name}} = $Args{_tstyle};
      $HxAlt{$Args{name}} = $Args{_alt};
    }
    if( (!$Args{nonumber}) and ($Args{_text} ne '') ) {
      $Doc{HXCOUNT}{$Args{name}}++;
      if( $Args{name} eq 'H1' ) {
        $Doc{HXCOUNT}{H2} = $Doc{HXCOUNT}{H3} = $Doc{HXCOUNT}{H4} = 0;
      } elsif( $Args{name} eq 'H2' ) {
        $Doc{HXCOUNT}{H3} = $Doc{HXCOUNT}{H4} = 0;
      } elsif( $Args{name} eq 'H3' ) {
        $Doc{HXCOUNT}{H4} = 0;
      }
      if( $Doc{HXNUMBERSTR}{$Args{name}} ) {
        my $tmp = $Doc{HXNUMBERSTR}{$Args{name}};
        $tmp =~ s/\{(H[1234])\}/$Doc{HXCOUNT}{$1}/ge;
        $Args{_text} = $tmp . $Args{_text};
      }
    }
    $Args{_outline} = (defined($HxOutline{$Args{name}}) and !$Args{nooutline});
    $Args{_olevel} = $HxOutline{$Args{name}} + 0;
    for my $name(qw(header headerall headereven headerodd footer footerall 
      footereven footerodd)) {
      if( $Args{$name} ne '' ) {
        $Args{_pageattr}{$name} = 
          $Args{$name} eq '*' ? $Args{_text} : $Args{$name};
      }
    }
  </eval>
  <do if="$Args{_pageattr}">
    <clone setvar="$Args{_tstyle}" caller="$Args{_tstyle}" 
      pageattr="$Args{_pageattr}"/>
  </do>
  <do if="$Args{_alt}">
    <clone setvar="$Args{_tstyle}" caller="$TStyle{default}" 
      style="$Args{_tstyle}"/>
  </do>
  <do if="$Args{_text} ne ''">
  <return>
    <do if="$Args{_alt}">
      <do if="$Args{_outline}">
        <do tag="$Args{_alt}">
          <text>
            <Text style="$Args{_tstyle}">
              <texts>
                <Outline title="$Args{_text}" level="$Args{_olevel}"/>
              </texts>
              <texts>$Args{_text}</texts>
            </Text>
          </text>
        </do>
      </do>
      <do unless="$Args{_outline}">
        <do tag="$Args{_alt}">
          <text><Text style="$Args{_tstyle}" texts="$Args{_text}"/></text>
        </do>
      </do>
    </do>
    <do unless="$Args{_alt}">
      <P pstyle="$Args{_pstyle}" tstyle="$Args{_tstyle}">
        <do if="$Args{_outline}">
          <Outline title="$Args{_text}" level="$Args{_olevel}"/>
        </do>
        <T>$Args{_text}</T>
      </P>
    </do>
  </return>
  </do>
</def>

<!--
  <HEADER>：各ページの上部に表示される内容を指定する
  <FOOTER>：各ページの下部に表示される内容を指定する
  属性：page=対象ページ this:そのページのみ、all:すべて、even:偶数ページ、
             odd:奇数ページ（省略するとall）
        hr=横罫線の指定。位置（t:上、b:下）、文字との間隔（省略すると3）、線幅（省略すると0.25）をカンマ区切りで
        pstyle=段落スタイル（$PStyle{default}にcloneされる）
        tstyle=テキストスタイル（$TStyle{default}にcloneされる）
        font=フォントオブジェクト（テキストスタイルでfontを指定するのと同じ）
        showargs=showの引数（カンマ区切りで）
        clear=真を指定すると対象の指定をクリア
        ※pageにthisを指定したときは<BODY>内に置かねば効果がない
        ※clearはpageがthisの時は無意味
  内容：テキスト（テキスト中の{page}はページ番号に置き換えられる）
-->
<alias tag="HEADER" aliasof="_HEADER_FOOTER" target="Header"/>
<alias tag="FOOTER" aliasof="_HEADER_FOOTER" target="Footer"/>
<def tag="_HEADER_FOOTER" page="all">
  <_SetTstyleOverDefault/>
  <_SetFontToTstyle/>
  <_SetPstyleOverDefault/>
  <eval>
    my($x, $y, $align);
    if( $Args{showargs} ) {
      ($x, $y, $align) = split /\s*,\s*/, $Args{showargs};
    }
    $x = $Doc{Bodyleft} unless defined $x;
    $y = $Args{target} eq 'Header' ? 
      $Doc{Bodytop} + $Doc{Topmargin} / 2 :
      $Doc{Bottommargin} / 2
      unless defined $y;
    $align ||= 'ml';
    $Args{showargs} = [$x, $y, $align];
  </eval>
  <do setvar="$Args{_text}" withtext="text" contents="$Args{contents}"/>
  <eval>
    if( $Args{clear} ) {
      delete $Doc{$Args{target}}{$Args{page}};
    } elsif( $Args{page} ne 'this' ) {
      $Doc{$Args{target}}{$Args{page}} = 
        [$Args{pstyle}, $Args{tstyle}, $Args{showargs}, $Args{_text}, $Args{hr}];
    }
  </eval>
  <do if="$Args{page} eq 'this'">
    <eval>
      $Args{_st} = {pageattr => {$Args{target} => 
        [$Args{pstyle}, $Args{tstyle}, $Args{showargs},$Args{_text}, $Args{hr}]}};
    </eval>
    <return>
      <Space size="0" style="$Args{_st}"/>
    </return>
  </do>
</def>

<!--
  <BODY>：その内容が空のブロックスタイルを持ったブロックに入り、
              自動的に分割されてページに配置される
  属性：page=開始ページ番号（この位置にページを挿入。省略すると末尾に追加）
        hfpage=ヘッダやフッタに表示するページ番号の開始値（省略するとpageと同じ）
             ※どちらも1以上を指定
             ※ヘッダやフッタのページ番号は<BODY>実行時に決まり、
               それ以降にページ挿入をおこなっても変わらないことに注意
        cols=段数（省略時値1）
        colskip=段間（省略時値20）
        evenpages=真ならページ数が偶数になるように空ページが付加される
-->
<def tag="BODY" page="0" hfpage="0" cols="1" colskip="20">
  <local setvar="$PStyle{default}"/>
  <eval>
    $Args{_bdir} = $Doc{Fontdirection} eq 'H' ? 'V' : 'R';
    $Args{page}--;
    $Args{_col} = 0;
    $Args{_colwidth} = ($Doc{Bodywidth} - $Args{colskip} * ($Args{cols} - 1)) /
      $Args{cols};
    $Args{_addedpages} = 0;
  </eval>
  <clone setvar="$PStyle{default}" caller="$PStyle{default}" 
    size="$Args{_colwidth}"/>
  <Block direction="$Args{_bdir}">
    <style><BStyle/></style>
    <objects><do contents="$Args{contents}"/></objects>
    <call>
      <break sizes="$Doc{Bodyheight}">
        <call>
          <do if="$Args{_col} % $Args{cols} == 0">
            <do if="$Args{page} >= 0">
              <insert_page caller="$Doc" setvar="$page" number="$Args{page}"/>
              <eval>$Args{page}++; $Args{_addedpages}++</eval>
            </do>
            <do unless="$Args{page} >= 0">
              <new_page caller="$Doc" setvar="$page"/>
              <eval>$Args{_addedpages}++</eval>
            </do>
            <eval>
              print "page",$page->pagenum,"\n" if $Args{'XPDFJ:verbose'} >= 0;
              $Args{hfpage} ||= $page->pagenum;
            </eval>
          </do>
          <eval>
            $Args{_left} = $Doc{Bodyleft} + ($Args{_col} % $Args{cols}) *
              ($Args{_colwidth} + $Args{colskip});
          </eval>
          <show page="$page" x="$Args{_left}" y="$Doc{Bodytop}" align="tl"/>
          <do if="$Args{_col} % $Args{cols} == 0">
            <for setvar="$Args{_hf}" eval="('Header', 'Footer')">
              <eval>
                my $name = lc($Args{_hf});
                for my $side(qw(odd even all)) {
                  if( $page->getattr("$name$side") ne '' ) {
                    $Doc{$Args{_hf}}{$side}[3] = $page->getattr("$name$side");
                  }
                }
                $Args{_hfa} = $page->getattr($Args{_hf});
                $Args{_hfa} ||= $Args{hfpage} % 2 ? $Doc{$Args{_hf}}{odd} : 
                  $Doc{$Args{_hf}}{even};
                $Args{_hfa} ||= $Doc{$Args{_hf}}{all};
              </eval>
              <do if="$Args{_hfa}">
                <eval>
                  ($Args{_pstyle}, $Args{_tstyle}, $Args{_showargs}, 
                    $Args{_text}, $Args{_hr}) = @{$Args{_hfa}};
                  my $name = lc($Args{_hf});
                  $Args{_ptext} = $page->getattr($name);
                  $Args{_text} = $Args{_ptext} if $Args{_ptext} ne '';
                  $Args{_text} =~ s/{page}/$Args{hfpage}/ge;
                  ($Args{_x}, $Args{_y}, $Args{_align}) = @{$Args{_showargs}};
                  if( $Args{_hr} ) {
                    $Args{_hrx} = $Args{_x};
                    $Args{_hrsize} = $Args{_pstyle}{size};
                    ($Args{_hrpos}, $Args{_hrskip}, $Args{_hrwidth}) = 
                      split /\s*,\s*/, $Args{_hr};
                    $Args{_hrskip} ||= 3;
                    $Args{_hrwidth} ||= 0.25;
                    if( $Args{_hrpos} eq 't' ) {
                      $Args{_hry} = $Args{_y} + $Args{_tstyle}{fontsize} / 2 +
                        $Args{_hrskip};
                    } else {
                      $Args{_hry} = $Args{_y} - $Args{_tstyle}{fontsize} / 2 -
                        $Args{_hrskip};
                    }
                  }
                </eval>
                <do if="$Args{_text} ne ''">
                  <Paragraph style="$Args{_pstyle}">
                    <text>
                      <Text style="$Args{_tstyle}" texts="$Args{_text}"/>
                    </text>           
                    <call>
                      <show page="$page" x="$Args{_x}" y="$Args{_y}" 
                        align="$Args{_align}"/>     
                    </call>
                  </Paragraph>
                  <do if="$Args{_hr}">
                    <Shape>
                      <style>
                        <SStyle linewidth="$Args{_hrwidth}"/>
                      </style>
                      <call>
                        <line x="0" y="0" w="$Args{_hrsize}" h="0"/>
                        <show page="$page" x="$Args{_hrx}" y="$Args{_hry}"/>
                      </call>
                    </Shape>
                  </do>
                </do>
              </do>
            </for>
          </do>
          <do if="$Args{_col} % $Args{cols} == $Args{cols} - 1">
            <eval>$Args{hfpage}++</eval>
          </do>
          <eval>$Args{_col}++</eval>
        </call>
      </break>
    </call>
  </Block>
  <do if="$Args{evenpages} and ($Args{_addedpages} % 2)">
    <do if="$Args{page} >= 0">
      <insert_page caller="$Doc" setvar="$page" number="$Args{page}"/>
    </do>
    <do unless="$Args{page} >= 0">
      <new_page caller="$Doc" setvar="$page"/>
    </do>
    <eval>
      print "page",$page->pagenum,"(empty page for evenpages)\n" 
        if $Args{'XPDFJ:verbose'} >= 0;
    </eval>
  </do>
</def>

</do>
