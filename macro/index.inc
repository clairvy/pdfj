<?xml version="1.0" encoding="x-sjis-cp932"?>
<!-- 
index.inc : 索引マクロ
2005 <nakajima@netstock.co.jp>
使用法：本文で、<INDEX reading="ごく" term="語句"/>語句 のようにしておき、
        例えば次のように本文の後に索引を作る
        <BODY cols="3">
        <H3>索引</H3>
        <MAKEINDEX/>
        </BODY>
-->

<do>

<!--
  読みから索引の頭文字を取り出すサブルーチン
-->
<eval>
  my @kindextitle = (
    [qw(ア ァ)],
    [qw(イ ィ)],
    [qw(ウ ゥ ヴ)],
    [qw(エ ェ)],
    [qw(オ ォ)],
    [qw(カ ガ ヵ)],
    [qw(キ ギ)],
    [qw(ク グ)],
    [qw(ケ ゲ ヶ)],
    [qw(コ ゴ)],
    [qw(サ ザ)],
    [qw(シ ジ)],
    [qw(ス ズ)],
    [qw(セ ゼ)],
    [qw(ソ ゾ)],
    [qw(タ ダ)],
    [qw(チ ヂ)],
    [qw(ツ ヅ)],
    [qw(テ デ)],
    [qw(ト ド)],
    [qw(ナ)],
    [qw(ニ)],
    [qw(ヌ)],
    [qw(ネ)],
    [qw(ノ)],
    [qw(ハ バ パ)],
    [qw(ヒ ビ ピ)],
    [qw(フ ブ プ)],
    [qw(ヘ ベ ペ)],
    [qw(ホ ボ ポ)],
    [qw(マ)],
    [qw(ミ)],
    [qw(ム)],
    [qw(メ)],
    [qw(モ)],
    [qw(ヤ ャ)],
    [qw(ユ ュ)],
    [qw(ヨ ョ)],
    [qw(ラ)],
    [qw(リ)],
    [qw(ル)],
    [qw(レ)],
    [qw(ロ)],
    [qw(ワ ヰ ヱ ヲ ン)],
    [qw(あ ぁ)],
    [qw(い ぃ)],
    [qw(う ぅ)],
    [qw(え ぇ)],
    [qw(お ぉ)],
    [qw(か が)],
    [qw(き ぎ)],
    [qw(く ぐ)],
    [qw(け げ)],
    [qw(こ ご)],
    [qw(さ ざ)],
    [qw(し じ)],
    [qw(す ず)],
    [qw(せ ぜ)],
    [qw(そ ぞ)],
    [qw(た だ)],
    [qw(ち ぢ)],
    [qw(つ づ)],
    [qw(て で)],
    [qw(と ど)],
    [qw(な)],
    [qw(に)],
    [qw(ぬ)],
    [qw(ね)],
    [qw(の)],
    [qw(は ば ぱ)],
    [qw(ひ び ぴ)],
    [qw(ふ ぶ ぷ)],
    [qw(へ べ ぺ)],
    [qw(ほ ぼ ぽ)],
    [qw(ま)],
    [qw(み)],
    [qw(む)],
    [qw(め)],
    [qw(も)],
    [qw(や ゃ)],
    [qw(ゆ ゅ)],
    [qw(よ ょ)],
    [qw(ら)],
    [qw(り)],
    [qw(る)],
    [qw(れ)],
    [qw(ろ)],
    [qw(わ ゐ ゑ を ん)],
  );
  $Index{KCharHash} = {};
  $Index{KCharLen} = length($kindextitle[0][0]);
  for my $chr(@kindextitle) {
    for my $ch(@$chr) {
      $Index{KCharHash}{$ch} = $chr->[0];
    }
  }
  sub indextitlechar {
    my($reading) = @_;
    my $result = ' ';
    my $ch;
    if( $reading =~ /^([A-Za-z])/ ) {
      $result = uc($1);
    } elsif( $ch = $Index{KCharHash}{substr($reading, 0, $Index{KCharLen})} ) {
      $result = $ch;
    }
    return $result;
  }
  $Index{TermText} = {};
</eval>

<!--
  <INDEX>：索引語を指定
  属性：term=索引語
        reading=読み（アルファベット、ひらがな、カタカナ）
        ※readingの英大文字小文字は区別されない
        ※termとreadingが同じ場合はreadingを省略できる
  内容：属性として解釈
-->
<def tag="INDEX" contentsmode="arg">
  <eval>
    $Args{reading} = $Args{term} if ($Args{reading} eq '' and !ref($Args{term}));
    $Args{reading} =~ tr/a-z/A-Z/;
    $Args{_dname} = 
      indextitlechar($Args{reading})."$;$Args{reading}$;$Args{term}";
    if( ref($Args{term}) ) {
      $Index{TermText}{$Args{term}} = $Args{term};
    }
  </eval>
  <return>
    <Dest name="$Args{_dname}"/>
  </return>
</def>

<!--
  <MAKEINDEX>：索引を作成し、その段落のリストを返す
  属性：beginindent=ページ番号群の行頭インデント（省略時値50）
        endindent=索引語の行末インデント（省略時値50）
        space=索引語とページ番号群の間の最小空白サイズ（省略時値20）
        dot=索引語とページ番号群の間を埋める文字列（省略時値"‥"）
        title=索引語頭文字を表示する文字列（{title}は頭文字に置換）（省略時値"－{title}－"）
        defaulttitle=英字仮名以外に対する索引語頭文字名（省略時値"記号・数字"）
  内容：属性として解釈
-->
<def tag="MAKEINDEX" contentsmode="arg" beginindent="50" endindent="50" 
  space="20" dot="‥" title="－{title}－" defaulttitle="記号・数字">
  <eval>
    $Args{_destnames} = [sort grep /$;/, $Doc->destnames];
    $Args{_lasttitle} = '';
    $Args{_altstyle} = {beginindent => $Args{beginindent}, endindent => 0,
      align => ['W', 'e']};
    $Args{_spaceglue} = [$Args{space} / $TStyle{default}{fontsize}, 
      $Args{space} / $TStyle{default}{fontsize}, 1000, 3];
    $Args{_spacestyle} = {filltext => $Args{dot}};
  </eval>
  <clone setvar="$Args{_pstyle}" caller="$PStyle{default}" 
    linefeed="120%" preskip="25%" postskip="25%" nobreak="1" align="b" 
    endindent="$Args{endindent}"/>
  <clone setvar="$Args{_titlepstyle}" caller="$PStyle{default}" align="m" 
    preskip="175%" postnobreak="1"/>
  <clone setvar="$Args{_tstyle}" caller="$TStyle{default}"/>
  <clone setvar="$Args{_titletstyle}" caller="$TStyle{default}" bold="1"/>
  <return>
    <for setvar="$Args{_dname}" eval="$Args{_destnames}">
      <eval>
        ($Args{_title}, $Args{_reading}, $Args{_term}) = split $;, $Args{_dname};
        $Args{_term} = $Index{TermText}{$Args{_term}} 
          if $Index{TermText}{$Args{_term}};
        $Args{_dpages} = $Doc->destpage($Args{_dname});
        $Args{_pagehash} = {};
        for my $pg(@{$Args{_dpages}}) {
          my $pn = $pg->[0]->pagenum;
          $Args{_pagehash}{$pn} = $pg unless $Args{_pagehash}{$pn};
        }
        $Args{_pagenums} = [sort {$a &lt;=&gt; $b} keys %{$Args{_pagehash}}];
      </eval>
      <do if="$Args{_title} ne $Args{_lasttitle}">
        <eval>
          $Args{_titletxt} = $Args{_title};
          $Args{_titletxt} = $Args{defaulttitle} if $Args{_titletxt} eq ' ';
          $Args{_titlestr} = $Args{title};
          $Args{_titlestr} =~ s/\{title\}/$Args{_titletxt}/g;
        </eval>
        <Paragraph style="$Args{_titlepstyle}">
          <text>
            <Text style="$Args{_titletstyle}" texts="$Args{_titlestr}"/>
          </text>
        </Paragraph>
        <eval>$Args{_lasttitle} = $Args{_title}</eval>
      </do>
      <Paragraph style="$Args{_pstyle}">
        <text>
          <Text style="$Args{_tstyle}">
            <texts>$Args{_term}</texts>
            <texts><Null style="$Args{_altstyle}"/></texts>
            <texts>
              <Space size="0" glue="$Args{_spaceglue}" 
                style="$Args{_spacestyle}"/>
            </texts>
            <texts>
              <eval>$Args{_needcomma} = 0</eval>
              <for setvar="$Args{_pagenum}" eval="$Args{_pagenums}">
                <eval>
                  $Args{_linkstyle} = {withbox => 'n', withboxstyle => 
                    {link => $Args{_pagehash}{$Args{_pagenum}}}};
                </eval>
                <do if="$Args{_needcomma}">
                  <Text texts=", ">
                    <style><TStyle/></style>
                  </Text>
                </do>
                <Text style="$Args{_linkstyle}" texts="$Args{_pagenum}"/>
                <eval>
                  $Args{_needcomma} = 1;
                </eval>
              </for>
            </texts>
          </Text>
        </text>
      </Paragraph>
    </for>
  </return>
</def>

</do>
