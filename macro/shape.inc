<?xml version="1.0" encoding="x-sjis-cp932"?>
<!-- 
  shape.inc : XPDFJの図形マクロ
  2004 <nakajima@netstock.co.jp>
-->
<do>

<require version="0.21"/>

<!--
  <SHAPE>：図形（Shapeオブジェクト）
  属性：style=図形スタイル（省略可）
  内容：<LINE><BOX><CIRCLE><ELLIPSE><POLYGON><SHAPEOBJ>などの並び
-->
<def tag="SHAPE" attributesname="attr">
  <Shape setvar="$Args{_shape}" attributes="$Args{attr}"/>
  <return>
    <do result="last" shape="$Args{_shape}" contents="$Args{contents}"/>
  </return>
</def>

<!--
  <LINE>：直線
  属性：（PDFJのlineメソッドの引数を参照）
  内容：属性として解釈
-->
<def tag="LINE" contentsmode="arg" attributesname="attr">
  <return>
    <line caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <BOX>：矩形
  属性：（PDFJのboxメソッドの引数を参照）
  内容：属性として解釈
-->
<def tag="BOX" contentsmode="arg" attributesname="attr">
  <return>
    <box caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <CIRCLE>：円
  属性：（PDFJのcircleメソッドの引数を参照）
  内容：属性として解釈
-->
<def tag="CIRCLE" contentsmode="arg" attributesname="attr">
  <return>
    <circle caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <ELLIPSE>：楕円
  属性：（PDFJのellipseメソッドの引数を参照）
  内容：属性として解釈
-->
<def tag="ELLIPSE" contentsmode="arg" attributesname="attr">
  <return>
    <ellipse caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <POLYGON>：多角形
  属性：（PDFJのpolygonメソッドの引数を参照）
        coords属性にはカンマ区切りで座標列を指定
  内容：属性として解釈
-->
<def tag="POLYGON" contentsmode="arg" attributesname="attr">
  <eval>
    $Args{attr}{coords} = [split /\s*,\s*/, $Args{attr}{coords}];
  </eval>
  <return>
    <polygon caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <SHAPEOBJ>：図形中の表示可能オブジェクト
  属性：obj=表示可能オブジェクト
        showargs="X,Y,配置" X,Yは位置（図形内での座標で）
        配置は次のl,c,rとt,m,bの組み合わせ
        Xに l:左端、c:中央、r:右端 を合わせる
        Yに t:上端、m:中央、b:下端 を合わせる
  内容：属性として解釈
-->
<def tag="SHAPEOBJ" contentsmode="arg" attributesname="attr">
  <eval>
    $Args{attr}{showargs} = [split /\s*,\s*/, $Args{attr}{showargs}];
  </eval>
  <return>
    <obj caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <BOUNDARY>：図形の境界
  属性：x=横位置
        y=縦位置
        指定した横位置と縦位置がこれまでの境界より外にあれば境界を広げる
        （境界を狭めることはできない）
  内容：属性として解釈
-->
<def tag="BOUNDARY" contentsmode="arg" attributesname="attr">
  <return>
    <setboundary caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <ARC>：円弧
  属性：（PDFJのarcメソッドの引数を参照）
  内容：属性として解釈
-->
<def tag="ARC" contentsmode="arg" attributesname="attr">
  <return>
    <arc caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <ARROW>：矢印
  属性：<LINE>の属性に加えて、
        headsize=鏃の長さ（省略すると8）
        headangle=鏃の先端角度の半分（ラジアン）（省略すると0.3）
        終端に鏃が付く
  内容：属性として解釈
-->
<def tag="ARROW" contentsmode="arg" attributesname="attr"
headsize="8" headangle="0.3">
  <return>
    <arrow caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <BRACE>：波括弧
  属性：x=横位置
        y=縦位置
        w=幅 
        h=高さ
        style=図形スタイル（オプション）
        x,y,w,hで決まる矩形の中に描かれる。
        wを負にすると閉じ括弧になる。
  内容：属性として解釈
-->
<def tag="BRACE" contentsmode="arg" attributesname="attr">
  <return>
    <brace caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <BRACKET>：角括弧
  属性：x=横位置
        y=縦位置
        w=幅 
        h=高さ
        style=図形スタイル（オプション）
        x,y,w,hで決まる矩形の中に描かれる。
        wを負にすると閉じ括弧になる。
  内容：属性として解釈
-->
<def tag="BRACKET" contentsmode="arg" attributesname="attr">
  <return>
    <bracket caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <PAREN>：丸括弧
  属性：x=横位置
        y=縦位置
        w=幅 
        h=高さ
        style=図形スタイル（オプション）
        x,y,w,hで決まる矩形の中に描かれる。
        wを負にすると閉じ括弧になる。
  内容：属性として解釈
-->
<def tag="PAREN" contentsmode="arg" attributesname="attr">
  <return>
    <paren caller="$Args{shape}" attributes="$Args{attr}"/>
  </return>
</def>

<!--
  <PARENBLOCK>：括弧付きブロック
  ※実験的なものなのでドキュメント未整備
-->
<def tag="PARENBLOCK" direction="V" type="paren" pwidth="5" padding="3">
  <eval>
    die "begin or end attribute required for BRACEBLOCK" 
      unless $Args{begin} || $Args{end};
  </eval>
  <Block setvar="$_iblock" direction="$Args{direction}">
    <style><BStyle/></style>
    <objects><do contents="$Args{contents}"/></objects>
  </Block>
  <eval>
    $_size = $_iblock->size($Args{direction});
    $_odir = $Args{direction} eq 'V' ? 'H' : 'V';
    $_objects = [];
  </eval>
  <do if="$Args{begin}">
    <SHAPE setvar="$_shape">
      <do if="$Args{type} eq 'brace'">
        <BRACE x="0" y="0" w="$Args{pwidth}" h="$_size"/>
      </do>
      <do if="$Args{type} eq 'bracket'">
        <BRACKET x="0" y="0" w="$Args{pwidth}" h="$_size"/>
      </do>
      <do if="$Args{type} eq 'paren'">
        <PAREN x="0" y="0" w="$Args{pwidth}" h="$_size"/>
      </do>
    </SHAPE>
    <SKIP setvar="$_skip" skip="$Args{padding}"/>
    <eval>
      push @$_objects, $_shape, $_skip;
    </eval>
  </do>
  <eval>
    push @$_objects, $_iblock;
  </eval>
  <do if="$Args{end}">
    <eval>
      $_pwidth = -$Args{pwidth};
    </eval>
    <SHAPE setvar="$_shape">
      <do if="$Args{type} eq 'brace'">
        <BRACE x="0" y="0" w="$_pwidth" h="$_size"/>
      </do>
      <do if="$Args{type} eq 'bracket'">
        <BRACKET x="0" y="0" w="$_pwidth" h="$_size"/>
      </do>
      <do if="$Args{type} eq 'paren'">
        <PAREN x="0" y="0" w="$_pwidth" h="$_size"/>
      </do>
    </SHAPE>
    <SKIP setvar="$_skip" skip="$Args{padding}"/>
    <eval>
      push @$_objects, $_skip, $_shape;
    </eval>
  </do>
  <return>
    <Block direction="$_odir" objects="$_objects">
      <style><BStyle/></style>
    </Block>
  </return>
</def>

</do>
