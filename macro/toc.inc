<?xml version="1.0" encoding="x-sjis-cp932"?>
<!-- 
toc.inc : 目次マクロ
2004 <nakajima@netstock.co.jp>
※アウトラインを目次化する。
※基本パターンは次のようになる。
<do file="stddefs.inc"/>
<do file="toc.inc"/>
<BODY>
…本文の内容…
</BODY>
<BODY page="1">
…表紙などの内容…
<TOC/>
</BODY>
-->

<do>

<!--
  アウトラインを入れ子の配列参照に変換するサブルーチン
-->
<eval>
  sub outlinetree2array {
    my($tree, $level) = @_;
    $level += 0;
    my $maxlevel = $level;
    my $result = [];
    for my $elm(@$tree) {
      my($title, $page, $x, $y, $child) = @$elm;
      push @$result, [$level, $title, $page, $x, $y] if $title ne '';
      if( ref($child) eq 'ARRAY' ) {
        my($carray, $clevel) = outlinetree2array($child, $level + 1);
        push @$result, @$carray;
        $maxlevel = $clevel if $clevel > $maxlevel;
      }
    }
    ($result, $maxlevel);
  }
</eval>

<!--
  <TOC>：アウトラインから目次を作成し、その段落リストを返す
  属性：levelindent=レベル毎のインデント量（省略時値10）
        endindent=表題の行末インデント（省略時値60）
        space=表題とページ番号の間の最小空白サイズ（省略時値30）
        dot=表題とページ番号の間を埋める文字列（省略時値"‥"）
        ※spaceはendindentより小さな値を指定すること
  内容：属性として解釈
-->
<def tag="TOC" contentsmode="arg" levelindent="10" endindent="60" 
  space="30" dot="‥">
  <eval>
    $Args{_indent1} = $Args{levelindent};
    $Args{_indent2} = $Args{levelindent} * 2;
    $Args{_indent3} = $Args{levelindent} * 3;
  </eval>
  <do caller="$PStyle{default}">
    <clone setvar="$PStyleHash{TOC0}" align="b" beginindent="0" 
      endindent="$Args{endindent}"/>
    <clone setvar="$PStyleHash{TOC1}" align="b" beginindent="$Args{_indent1}"
      endindent="$Args{endindent}"/>
    <clone setvar="$PStyleHash{TOC2}" align="b" beginindent="$Args{_indent2}"
      endindent="$Args{endindent}"/>
    <clone setvar="$PStyleHash{TOC3}" align="b" beginindent="$Args{_indent3}"
      endindent="$Args{endindent}"/>
  </do>
  <do caller="$TStyle{default}">
    <clone setvar="$TStyleHash{TOC0}" bold="1"/>
    <clone setvar="$TStyleHash{TOC1}"/>
    <clone setvar="$TStyleHash{TOC2}"/>
    <clone setvar="$TStyleHash{TOC3}"/>
  </do>
  <eval>
    ($Args{_array}, $Args{_maxlevel}) = outlinetree2array($Doc->outlinetree);
    if( $Args{_maxlevel} > 1 ) {
      $PStyleHash{TOC0}{preskip} = $Doc{Fontsize} * 2;
      $PStyleHash{TOC0}{postnobreak} = 1;
    } else {
      delete $PStyleHash{TOC0}{preskip};
      delete $PStyleHash{TOC0}{postnobreak};
    }
    $Args{_spaceglue} = [$Args{space} / $TStyle{default}{fontsize}, 
      $Args{space} / $TStyle{default}{fontsize}, 1000, 3];
    $Args{_spacestyle} = {filltext => $Args{dot}};
  </eval>
  <for setvar="$Args{_elm}" eval="$Args{_array}">
    <eval>
      @Args{qw(_level _title _page _x _y)} = @{$Args{_elm}};
      $Args{_pagenum} = $Args{_page}->pagenum;
      $Args{_name} = "TOC$Args{_level}";
      $Args{_pstyle} = $PStyleHash{$Args{_name}};
      $Args{_tstyle} = $TStyleHash{$Args{_name}};
      $Args{_altstyle} = {align => [qw(W e)], endindent => 0};
      $Args{_linkstyle} = {withbox => 'n', 
        withboxstyle => {link => [@Args{qw(_page _x _y)}]}};
    </eval>
    <clone setvar="$Args{_ttstyle}" caller="$Args{_tstyle}" 
      style="$Args{_linkstyle}"/>
    <Text setvar="$Args{_title}" style="$Args{_ttstyle}" texts="$Args{_title}"/>
    <Text setvar="$Args{_page}" style="$Args{_tstyle}" texts="$Args{_pagenum}"/>
    <return>
      <Paragraph style="$Args{_pstyle}">
        <text>
          <Text style="$Args{_tstyle}">
            <texts>$Args{_title}</texts>
            <texts><Null style="$Args{_altstyle}"/></texts>
            <texts>
              <Space size="0" glue="$Args{_spaceglue}" 
                style="$Args{_spacestyle}"/>
            </texts>
            <texts>$Args{_page}</texts>
          </Text>
        </text>
      </Paragraph>
    </return>
  </for>
</def>

</do>
