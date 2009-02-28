<?xml version="1.0" encoding="x-sjis-cp932"?>
<!--
article.inc - 論文用マクロ
2004 <nakajima@netstock.co.jp>
このマクロを使用した原稿の構造は、次のようになる
<XPDFJ version="0.2">
<do file="article.inc"/>
<ARTICLE>
  <HEAD>
    <TITLE>,<ETITLE>,<AUTHOR>,<EAUTHOR>,<SUMMARY>,<ESUMMARY>の並び
  </HEAD>
  <BODY>
    <SECTITLE>,<SUBSECTITLE>,<P>,<UL>,<OL>,<DL>,<TABLE>,<FOOTNOTE>,<FIG>,<REFERENCE>の並び
  </BODY>
</ARTICLE>
<print file="…"/>
</XPDFJ>
-->

<do>

<!--
標準マクロの組み込み
紙サイズと余白はここで調整
フォントサイズも変更できるが、見出し等のサイズとのバランス調整が必要
-->
<do file="stddefs.inc" 
	pagewidth="595" pageheight="842"
	leftmargin="42" rightmargin="42" topmargin="56" bottommargin="56"
	fontsize="9" labelsize="9"
	fontfiles="stdfontsH.inc" boldmincho="GothicBBB-Medium" 
/>

<!--
追加のグローバル変数
$Doc{Columngap} : 段組の段間
$Doc{HeadBodySkip} : ヘッダ部と本文部の間隔
-->
<eval>
	$Doc{Columngap} = 20;
	$Doc{HeadBodySkip} = 30;
	$Font{normal} = $FontH{mincho_times};
	$Font{bold} = $FontH{mincho_times_bold};
</eval>

<!--
行間の調整
150%ではちょっとだけ窮屈な感じがするので
subsectitleも合わせること
-->
<clone setvar="$PStyle{default}" caller="$PStyle{default}" linefeed="160%"/>

<!--
  <TITLE>：表題
  <ETITLE>：表題（英文表記）
  <AUTHOR>：著者
  <EAUTHOR>：著者（英文表記）
  <SUMMARY>：概要
  <ESUMMARY>：概要（英文表記）
  内容：テキスト（改行はNewLineに）
-->
<TStyle setvar="$TStyle{title}" font="$Font{bold}" fontsize="16"/>
<PStyle setvar="$PStyle{title}" size="$Doc{Bodywidth}" align="m" linefeed="120%" preskip="10" postskip="20"/>

<TStyle setvar="$TStyle{etitle}" font="$Font{bold}" fontsize="14"/>
<PStyle setvar="$PStyle{etitle}" size="$Doc{Bodywidth}" align="m" linefeed="120%" preskip="10" postskip="20"/>

<TStyle setvar="$TStyle{author}" font="$Font{normal}" fontsize="12"/>
<PStyle setvar="$PStyle{author}" size="$Doc{Bodywidth}" align="m" linefeed="120%" preskip="0" postskip="20"/>

<TStyle setvar="$TStyle{eauthor}" font="$Font{normal}" fontsize="12"/>
<PStyle setvar="$PStyle{eauthor}" size="$Doc{Bodywidth}" align="m" linefeed="120%" preskip="0" postskip="20"/>

<TStyle setvar="$TStyle{summary}" font="$Font{normal}" fontsize="8"/>
<PStyle setvar="$PStyle{summary}" size="$Doc{Bodywidth}" align="w" linefeed="130%" preskip="0" postskip="20" beginindent="40" endindent="40"/>

<TStyle setvar="$TStyle{esummary}" font="$Font{normal}" fontsize="8"/>
<PStyle setvar="$PStyle{esummary}" size="$Doc{Bodywidth}" align="w" linefeed="120%" preskip="0" postskip="20" beginindent="40" endindent="40"/>

<alias tag="TITLE" aliasof="_P" pstyle="$PStyle{title}" tstyle="$TStyle{title}"/>
<alias tag="ETITLE" aliasof="_P" pstyle="$PStyle{etitle}" tstyle="$TStyle{etitle}"/>

<alias tag="AUTHOR" aliasof="_P" pstyle="$PStyle{author}" tstyle="$TStyle{author}"/>
<alias tag="EAUTHOR" aliasof="_P" pstyle="$PStyle{eauthor}" tstyle="$TStyle{eauthor}"/>

<alias tag="SUMMARY" aliasof="_P" pstyle="$PStyle{summary}" tstyle="$TStyle{summary}"/>
<alias tag="ESUMMARY" aliasof="_P" pstyle="$PStyle{esummary}" tstyle="$TStyle{esummary}"/>

<!--
  <SECTITLE>：章見出し
  <SUBSECTITLE>：節見出し
  属性：label=ラベル（省略可）
  内容：テキスト（改行はNewLineに）
  ※label属性を省略すると、章見出しは「1.」、節見出しは「1.1」の番号ラベルが自動的に付く。label属性を指定すると番号ラベルは付かず（番号のカウントアップもされない）指定したラベルが付く
-->
<TStyle setvar="$TStyle{sectitle}" font="$Font{bold}" fontsize="10"/>
<PStyle setvar="$PStyle{sectitle}" size="$Doc{Bodywidth}" align="b" linefeed="3.5" preskip="8.5" postskip="8.5" beginpadding="9" labelsize="15" postnobreak="1"/>

<TStyle setvar="$TStyle{subsectitle}" font="$Font{bold}" fontsize="9"/>
<PStyle setvar="$PStyle{subsectitle}" size="$Doc{Bodywidth}" align="b" linefeed="160%" beginpadding="9" labelsize="20" postnobreak="1"/>

<def tag="SECTITLE">
  <eval>
    if( $Args{label} eq '' ) {
      $SecNumber++;
      $SubSecNumber = 0;
      $_label = "$SecNumber.";
    } else {
      $_label = $Args{label};
    }
  </eval>
  <clone setvar="$_pstyle" caller="$PStyle{sectitle}">
    <labeltext><Text texts="$_label" style="$TStyle{sectitle}"/></labeltext>
  </clone>
  <return>
    <Paragraph style="$_pstyle">
      <text>
        <Text style="$TStyle{sectitle}">
          <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
        </Text>
      </text>
    </Paragraph>
  </return>
</def>

<def tag="SUBSECTITLE">
  <eval>
    if( $Args{label} eq '' ) {
      $SubSecNumber++;
      $_label = "$SecNumber.$SubSecNumber";
    } else {
      $_label = $Args{label};
    }
  </eval>
  <clone setvar="$_pstyle" caller="$PStyle{subsectitle}">
    <labeltext><Text texts="$_label" style="$TStyle{subsectitle}"/></labeltext>
  </clone>
  <return>
    <Paragraph style="$_pstyle">
      <text>
        <Text style="$TStyle{subsectitle}">
          <texts><do withtext="autonl" contents="$Args{contents}"/></texts>
        </Text>
      </text>
    </Paragraph>
  </return>
</def>

<!--
  <FOOTNOTE>：脚注
  属性：label=ラベル
  内容：テキスト（改行はNewLineに）
  ※float="e1"でページ下部に配置される（float="e"のFIGのさらに下に）
-->
<TStyle setvar="$TStyle{footnote}" font="$Font{normal}" fontsize="8"/>
<PStyle setvar="$PStyle{footnote}" size="$Doc{Bodywidth}" align="w" linefeed="150%" labelsize="16" labelskip="8" float="e1"/>

<alias tag="FOOTNOTE" aliasof="_PL" pstyle="$PStyle{footnote}" tstyle="$TStyle{footnote}"/>

<!--
  <CAPTION>：図表のキャプション
  <ECAPTION>：図表のキャプション（英文表記）
  属性：label=ラベル
  内容：テキスト（改行はNewLineに）
-->
<TStyle setvar="$TStyle{caption}" font="$Font{normal}" fontsize="8"/>
<PStyle setvar="$PStyle{caption}" size="$Doc{Bodywidth}" align="m" linefeed="130%" preskip="3" postskip="3"/>

<TStyle setvar="$TStyle{ecaption}" font="$Font{normal}" fontsize="8"/>
<PStyle setvar="$PStyle{ecaption}" size="$Doc{Bodywidth}" align="m" linefeed="120%" preskip="3" postskip="3"/>

<alias tag="CAPTION" aliasof="_P" pstyle="$PStyle{caption}" tstyle="$TStyle{caption}"/>
<alias tag="ECAPTION" aliasof="_P" pstyle="$PStyle{ecaption}" tstyle="$TStyle{ecaption}"/>

<!--
  <FIG>：図表
  属性：float=配置。b:上部、e:下部、h:分割せず可能ならその位置（省略するとb）
  内容：<CAPTION>、<ECAPTION>または任意のオブジェクト
  ※内容の全体が一つのブロックとなってfloat="b"でページ上部に配置される
-->
<def tag="FIG" float="b">
  <return>
    <Block direction="V">
      <style>
        <BStyle nobreak="1" float="$Args{float}" align="c" 
        preskip="10" postskip="10"/>
      </style>
      <objects><do contents="$Args{contents}"/></objects>
    </Block>
  </return>
</def>

<!--
  <REFERENCE>：参考文献
  属性：label=ラベル
  内容：テキスト（改行はNewLineに）
-->
<TStyle setvar="$TStyle{reference}" font="$Font{normal}" fontsize="8"/>
<PStyle setvar="$PStyle{reference}" size="$Doc{Bodywidth}" align="w" linefeed="150%" labelsize="16" labelskip="4"/>

<alias tag="REFERENCE" aliasof="_PL" pstyle="$PStyle{reference}" tstyle="$TStyle{reference}"/>

<!--
  <ARTICLE>：論文全体
  属性：col=段数（1または2、省略すると2）
  内容：<HEAD><BODY>
-->
<def tag="ARTICLE" col="2">
  <eval>
    die "'col' must be 1 or 2" unless $Args{col} == 1 || $Args{col} == 2;
    if( $Args{col} == 2 ) {
      $Doc{Columnwidth} = ($Doc{Bodywidth} - $Doc{Columngap}) / 2;
      $PStyle{sectitle}{size} = $Doc{Columnwidth};
      $PStyle{subsectitle}{size} = $Doc{Columnwidth};
      $PStyle{footnote}{size} = $Doc{Columnwidth};
      $PStyle{caption}{size} = $Doc{Columnwidth};
      $PStyle{ecaption}{size} = $Doc{Columnwidth};
      $PStyle{reference}{size} = $Doc{Columnwidth};
    }
  </eval>
  <do contents="$Args{contents}" col="$Args{col}"/>
  <height setvar="$Args{_headlen}" caller="$ArticleBlock{Head}"/>
  <eval>
    $_headlen = $Args{_headlen} + $Doc{HeadBodySkip};
    $_sizes = $Args{col} == 1 ? 
      [$Doc{Bodyheight} - $_headlen, $Doc{Bodyheight}] :
      [$Doc{Bodyheight} - $_headlen, $Doc{Bodyheight} - $_headlen,
      $Doc{Bodyheight}];
    $_count = 0;
  </eval>
  <new_page setvar="$_page"/>
  <eval>print "page",$_page->pagenum,"\n"</eval>
  <show page="$_page" caller="$ArticleBlock{Head}" 
  x="$Doc{Bodyleft}" y="$Doc{Bodytop}" align="tl"/>
  <break sizes="$_sizes" caller="$ArticleBlock{Body}">
    <call>
      <eval>
        $_count++;
        $_newpage = 0;
        if( ($Args{col} == 1 and $_count &gt; 1 ) ||
          ($Args{col} == 2 and $_count &gt; 2 and $_count % 2) ) {
          $_newpage = 1;
        }
        if( $Args{col} == 1 ) {
          $_x = $Doc{Bodyleft};
          $_y = $_count &lt;= 1 ? $Doc{Bodytop} - $_headlen : $Doc{Bodytop};
        } else {
          $_x = $_count % 2 ? $Doc{Bodyleft} : 
            $Doc{Bodyleft} + $Doc{Columnwidth} + $Doc{Columngap};
          $_y = $_count &lt;= 2 ? $Doc{Bodytop} - $_headlen : $Doc{Bodytop};
        }
      </eval>
      <do if="$_newpage">
        <new_page setvar="$_page" caller="$Doc"/>
        <eval>print "page",$_page->pagenum,"\n"</eval>
      </do>
      <show page="$_page" x="$_x" y="$_y" align="tl"/>
    </call>
  </break>
</def>

<!--
  <HEAD>：ヘッダ部
  内容：<TITLE>,<ETITLE>,<AUTHOR>,<EAUTHOR>,<SUMMARY>,<ESUMMARY>の並び
-->
<def tag="HEAD">
  <Block setvar="$ArticleBlock{Head}" direction="V">
    <style><BStyle/></style>
    <objects><do contents="$Args{contents}"/></objects>
  </Block>
  <height setvar="$Args{_height}" caller="$ArticleBlock{Head}"/>
  <eval>
    die "too long HEAD" 
      if $Args{_height} + $Doc{HeadBodySkip} &gt;= $Doc{Bodyheight};
  </eval>
</def>

<!--
  <BODY>：本文部
  内容：<SECTITLE>,<SUBSECTITLE>,<P>,<UL>,<OL>,<DL>,<TABLE>,<FOOTNOTE>,<FIG>,<REFERENCE>の並び
-->
<def tag="BODY">
  <do if="$Args{col} == 2">
    <clone setvar="$PStyle{default}" caller="$PStyle{default}" 
    size="$Doc{Columnwidth}"/>
  </do>
  <eval>$_width = $PStyle{default}{size}</eval>
  <Block setvar="$ArticleBlock{Body}" direction="V">
    <style><BStyle>
      <bfloatsep><BlockSkip skip="10"/></bfloatsep>
      <efloatsep><BlockSkip skip="10"/></efloatsep>
      <efloatsep>
        <Shape>
          <style><SStyle preskip="5" postskip="5" linewidth="0.25"/></style>
          <call><line x="0" y="0" w="$_width" h="0" style="s"/></call>
        </Shape>
      </efloatsep>
    </BStyle></style>
    <objects><do contents="$Args{contents}"/></objects>
  </Block>
</def>

</do>
