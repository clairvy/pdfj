PDFJ - 日本語PDF生成モジュール
バージョン 0.90

2006/10/22
中島 靖 <nakajima@netstock.co.jp>

※0.72でXPDFJのマクロを自作していた方は、0.73から<def>の書き方が変わっており従来のマクロは書き換えが必要ですので注意してください。

※0.84でブロックのbeginpaddingスタイルが廃止されました。代替機能としてはblockalignスタイルがあります。

※0.88RC1からOpenTypeフォントがサポートされましたが、十分なテストができていません。OpenTypeフォントをお持ちの方は是非テストしてレポートをお寄せください。

※0.89RC1から対話フォーム機能が実装され、そのデモを兼ねてPDFJフィードバックシート（sampleディレクトリのfeedback.xpから生成）が付属しています。是非フィードバックをお寄せください。今後の開発の参考にさせていただきます。


【ファイル構成】

readme.txt  … このファイル
Makefile.PL … インストール時に使われるスクリプト

・モジュール
PDFJ.pm     … PDFJの本体のモジュールファイル
PDFJ/*.pm   … PDFJ.pmから呼ばれて使われる下請けモジュール
XPDFJ.pm    … PDFJのXMLフロントエンドであるXPDFJのモジュールファイル

・説明書（docディレクトリ）
PDFJ.jp.pdf … PDFJ説明書（PDFJ.jp.podをpod2pdf.plで処理したもの）
PDFJ.jp.pod … PDFJ説明書のpod形式でのソース
XPDFJ.jp.pdf… XPDFJ説明書（XPDFJ.jp.podをpod2pdf.plで処理したもの）
XPDFJ.jp.pod… XPDFJ説明書のpod形式でのソース
CTK.txt     … 中国語（簡体）、中国語（繁体）、韓国語フォントの使用法
CHANGES     … 変更点を記載している
TODO        … 今後の予定を記載している

・PDFJのサンプルスクリプト（sampleディレクトリ）
demo.pl     … サンプルスクリプト（demo.pdfを生成）
demo.pdf    … demo.plによって生成されたPDFファイル
nouhinsho.pl… サンプルスクリプト（納品書作成）
nouhinsho.dat…nouhinsho.plのサンプルデータ
barcode.pl  … サンプルスクリプト（バーコード生成）
qrcode.pl   … サンプルスクリプト（QRコード生成）
pdfjclass.pl… サンプルスクリプト（PDFJのクラス図を生成）
pdfjclass.pdf…pdfjclass.plによって生成されたPDFファイル

・PDF作成ツール（utilディレクトリ）
text2pdf.pl … テキストファイルをPDFにするスクリプト
text2pdf.pl.cfg…text2pdf.plの設定ファイル（このファイルはEUC）
text2pdf.txt… text2pdf.plの説明書
pod2pdf.pl  … POD形式ソースをPDFにするスクリプト
xpdfj.pl    … XPDFJを使ってXMLからPDFを生成するスクリプト

・XPDFJのマクロ（macroディレクトリ）
stddefs.inc … XPDFJ用の標準マクロファイル
stdfontsH.inc…XPDFJ用のフォント定義ファイル（横書用）
stdfontsV.inc…XPDFJ用のフォント定義ファイル（縦書用）
shape.inc   … XPDFJ用の図形マクロファイル
article.inc … XPDFJ用の論文用マクロファイル
toc.inc     … XPDFJ用の目次用マクロファイル
index.inc   … XPDFJ用の索引用マクロファイル

・XPDFJのサンプル（sampleディレクトリ）
feedback.xp   … PDFJフィードバックシート
demo.xp       … demo.plをXPDFJ用のXMLに書き直したもの（マクロ使用無し）
kof2002.xp    … XPDFJ用のサンプルXML（マクロ機能を使用）（kof2002でのスライド）
kof2002.inc   … kof2002.xpから読み込まれる
kof2002.xp.pdf… kof2002.xpから生成されたPDFファイル
kof2004.xp    … XPDFJ用のサンプルXML（マクロ機能を使用）（kof2004でのスライド）
kof2004.xp.pdf… kof2004.xpから生成されたPDFファイル
articledemo.xp…article.incを使用したサンプルXML
articledemo.pdf…articledemo.xpから生成されたPDFファイル
stdmacro.xp   … stddefs.inc、toc.inc、index.incのデモ兼説明
stdmacro.xp.pdf…stdmacro.xpから生成されたPDFファイル
WinMacEnc.xp  … WinAnsiEncodingとMacRomanEncodingの表を作る
WinMacEnc.pdf … WinMacEnc.xpから生成されたPDFファイル

・その他のツール（utilディレクトリ）
ttfinfo.pl  … TrueTypeフォントファイル(.ttf)の内容を調べるスクリプト
ttcinfo.pl  … TrueTypeCollectionファイル(.ttc)の内容を調べるスクリプト
otfinfo.pl  … OpenTypeフォントファイル(.otf)の内容を調べるスクリプト


【インストール】

管理者であれば次の標準的な手順でインストールできる。

  perl Makefile.PL
  make
  make install

最後のmake installは管理者権限で実行する。Windowsではmakeでなくnmakeを使用する。

※nmakeは次で入手できる。
  ftp://ftp.microsoft.com/Softlib/MSLFILES/nmake15.exe

管理者でない場合でも、PDFJを構成する次のモジュールファイル群をPerlから利用できる（すなわち@INCにセットされた）ディレクトリにおけば利用できる。

  PDFJ.pm
  PDFJ/*.pm

PDFJは、欧文のハイフネーションをおこなうために、TeX::Hyphenモジュールを使用している。欧文を含むテキストを扱う場合は必要となる。Perlモジュールのインストールは、管理者権限で「perl -MCPAN -e shell」と実行して（WindowsのActivePerlの場合はプログラムメニューから「Perl Package Manager」を選べばよい）、「install モジュール名」とすればよい。管理者でない場合は、CPANサイトからダウンロードして展開し、次のモジュールをPerlから利用できるディレクトリにおけばよい。

  TeX/Hyphen.pm
  TeX/Hyphen/czech.pm
  TeX/Hyphen/german.pm

PDFJは、フォントや画像などのデータを埋め込む際に、デフォルトではCompress::Zlibモジュールを使用する。Compress::Zlibがない環境や、Compress::Zlibを使いたくない場合のために、Compress::Zlibを使わずにデータの埋め込みをおこなうオプションも用意されている。

暗号化をおこなう際にはDigest::MD5モジュールを使用する。


【説明書について】

まず最初に、sampleディレクトリにある、articledemo.pdf、kof2002.xp.pdf、kof2004.xp.pdf、stdmacro.xp.pdf、demo.pdfをご覧いただくと、PDFJがどんなソフトで、どんなことができるか概要を掴んでいただけると思います。これらのpdfファイル自体がPDFJおよびXPDFJによって作られたものです。

docディレクトリにある、PDFJ.jp.pdfがPDFJの、XPDFJ.jp.pdfがXPDFJの、それぞれ説明書ですのでご覧下さい。

macroディレクトリにある各マクロファイルについては、まずkof2004.xp.pdfとstdmacro.xp.pdfをご覧ください。また、各マクロファイル自体の中に簡単な説明を記載しています。

PDFJ0.79から、中国語（簡体）、中国語（繁体）、韓国語の各フォントの使用が可能になりました。ただしこれはまだ実験的な機能であり、不完全なものです。CTK.txtをご覧ください。


【サンプルスクリプトtext2pdf.plについて】

プレーンテキストの原稿をpdfファイルに変換します。

  perl text2pdf.pl 入力ファイル 出力ファイル

と実行します。出力ファイルを省略すると入力ファイルに.pdfを付加したファイル名。

text2pdf.txtが説明書です。このファイル自身をtext2pdf.plで処理していただくと、どんなものかわかると思います。


【サンプルスクリプトpod2pdf.plについて】

Perlの標準的な説明書記述形式であるPODをpdfに変換します。

  perl pod2pdf.pl -s 入力ファイル 出力ファイル
  perl pod2pdf.pl -e 入力ファイル 出力ファイル

と実行します。-sは入力ファイルがシフトJISの場合、-eは日本語EUCの場合です。

実行するには、Pod::Parserモジュールが必要です。（Perl5.6以降には標準添付）

あくまでサンプルであり、次の制約があります。

・=begin、=end、=forは無視される
・タブのスペースへの置き換えはおこなわれない
・B<…>などの内部シーケンスは次のものだけが処理され、それ以外は元の文字列そのものとなる
  I<> B<> C<> F<> E<lt> E<gt> E<sol> E<verbar> L<"…"> L<…|"…"> X<>
  ※L<>のリンク先は、=head1と=head2の見出し、X<>で指定した場所、URL（https?、ftp、mailto）へのリンクのみ可能
  ※X<>はリンク先名の指定となる（それ自体は表示されない）


【サンプルスクリプトnouhinsho.plについて】

帳票作成のサンプルです。

  perl nouhinsho.pl nouhinsho.dat nouhinsho.pdf

で、データファイルnouhinsho.datに従って、nouhinsho.pdfが作成されます。


【サンプルスクリプトbarcode.plとqrcode.plについて】

バーコードとQRコードのサンプルです。GD::Barcodeが必要です。

  perl barcode.pl テキスト 種類 出力ファイル

  perl qrcode.pl テキスト ECC バージョン 出力ファイル

種類、ECC、バージョンについてはGD::Barcodeのドキュメントを参照してください。


【サンプルスクリプトpdfjclass.plについて】

ツリーブロックの応用例として、PDFJのクラス階層図をツリーの形で表示するというサンプルです。


【XPDFJ関係】

XPDFJを使用するには、XML::Parserモジュールが必要です。

XPDFJの書式によるXMLファイルをPDFに変換するには、

  perl xpdfj.pl 入力ファイル 出力ファイル

と実行します。出力ファイルを省略すると入力ファイルに.pdfを付加したファイル名。

オプション引数として、-d、-v、-p があります。
  -d1 … <debuginfo>が有効になる
  -vX … verboseフラグがXにセットされる。Xは数値
  -p ディレクトリ … <do file="…"/>でマクロファイルを読み込むときの検索パス

-vで-1を指定すると進行状況の表示が抑制されます。1または2を指定するとデバッグ用のメッセージが表示されます。

サンプルのXMLファイルとして、feedback.xp、demo.xp、kof2002.xp、kof2004.xp、stdmacro.xp、articledemo.xpが付属しています。

feedback.xpは、対話フォーム機能のデモを兼ねてPDFJフィードバックシートを生成します。是非このシートからご意見等をお寄せください。

demo.xpは、demo.plの内容をマクロ機能を使わずにストレートにXML化したものです。

kof2002.xpとkof2004.xpは、stddefs.incを使用したプレゼン用資料の例。

stdmacro.xpは、stddefs.inc,toc.inc,index.incを使用した目次や索引のある文書の例として、stddefs.inc,toc.inc,index.incの使い方の概略を説明しています。

articledemo.xpはarticle.incを使用した論文の例となっています。


【TrueType、OpenTypeフォントツール】

TrueTypeおよびOpenTypeフォントの内容を調べるためのツールとして、.ttf用のttfinfo.pl、.ttc用のttcinfo.pl、.otf用のotfinfo.plが付属している。

.ttcファイルに含まれるフォント名（Postscriptフォント名）を見たいときは、

  perl ttcinfo.pl foo.ttc -n

のようにする。

フォントの詳しい内容を見たい場合は、

  perl ttfinfo.pl bar.ttf

  perl ttcinfo.pl foo.ttc

  perl otfinfo.pl boo.otf

のようにすると、bar.ttf.info、foo.ttc.info、boo.otf.info というファイルが作られる。


【使用条件】

本ソフトウェアは誰でも自由に使用、配布、改良およびそれらの組み合わせをおこなうことができます。ただし、改良したものを配布する場合は原著作者の表示を保持してください。

本ソフトウェアは無保証であり、使用した結果に対しても責任を負えません。

本ソフトウェアはαバージョンの段階にあり、予告なく仕様が変更されることが大いにあり得ます。

※バージョン番号に「RC」と付いたものはテストバージョンですので、配布、転載はご遠慮ください。


【気づいた点は…】

本ソフトウェアについてのバグレポート、ご意見などは、下記のメーリングリストにご参加の上、投稿ください。ただし、バグの修正やご質問への回答についてお約束するものではなく、みんなでよりよいソフトウェアを作っていこうという趣旨で運営しております。よろしくお願いします。

PDFJメーリングリスト：
参加申込用アドレス：nakajima.yasushi-pdfj-subscribe@jonex.ne.jp
投稿用アドレス：nakajima.yasushi-pdfj@jonex.ne.jp

謝辞：本ソフトウェアの作成にあたっては、Kansai.pmのみなさんから多くの提案や励ましや催促(^^)をいただきました。また、上記メーリングリストでも多くの方からバグレポートをいただきました。記して感謝いたします。
