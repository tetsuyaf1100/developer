## 第6章 テストツールの導入<a name="testtool"></a><br/>

本ガイドの開発テストで使用するテストツールの導入手順と実行コマンドを示します。<br/>
テストツールは仮想サーバ（CentOS7）へ導入します。<br/>
実行コマンドはJenkinsのジョブ作成の際に利用します。<br/>

-----------------------------------------------------------------------------------------------

### 6-1.各種テストツール導入と実行コマンド

Markdown ファイル構文チェックツール <br/>
 >参考：[ Markdownlint ](https://github.com/mivok/markdownlint)<br/>
 >Markdownlint は ruby 形式のため ruby の導入が必要<br/>
 >以下、ruby は導入済みの前提で
 > ```
 >  gem install mdl
 >  git clone https://github.com/mivok/markdownlint
 >  cd markdownlint
 >  rake install
 >
 >  # テスト実施コマンド
 >  mdl < Markdown ファイル>
 > ```

html 構文チェックツール<br>
 > 参考：[ HTMLHint ](http://htmlhint.com/)<br/>
 > 導入の前提としてnodeのバージョンがv0.11.15以上必要です。<br/>
 >
 > ```
 >  npm install htmlhint -g
 >
 >  # テスト実施コマンド
 >  cat <チェックするファイル.html> | htmlhint stdin
 >  # またはチェックしたいファイルがあるディレクトリへ入って
 >  htmlhint
 > ```


アタックテスト（脆弱性検査）ツール<br/>

 > 参考：[ Skipfish ](https://code.google.com/archive/p/skipfish/wikis/SkipfishDoc.wiki)<br/>
 > Skipfish は Google が開発した脆弱性検査ツールで、CUI 環境での利用になります。<br/>
 > 検査対象の Webサイトに対しクローリングを行い、アクセス可能な URL を抽出し、
 > それらに対しさまざまなパターンで問題の発生しそうな URL やリクエストを生成して
 > アクセスすることで調査を行います。<br/>
 > 調査結果は html ファイル形式のレポートで作成され、ブラウザで確認できるようになっています。<br/>
 >
 > 以下、CentOS7 への導入手順です。<br/>
 >
 > ```
 > #事前準備として libidn と libpcre3 が必要になります。
 > yum install openssl-devel
 > yum install openssl-devel
 > yum install libidn-devel
 >
 > # Skipfishをインストールします。
 > # ダウンロードサイト https://code.google.com/archive/p/skipfish/
 > # インストールしたらファイルを解凍します。
 > tar xvzf skipfish-2.10b.tgz
 > # 解凍され展開されたディレクトリに入り、
 > cd skipfish-2.10b
 > # make コマンドでソースからプログラムをビルドします。
 > make
 > ```
 > 検査を行うには次のコマンドを実行します。<br/>
 > `./skipfish -o <出力先ディレクトリ名> <検査対象サイト url>` <br/>
 > なおSkipfishのコマンドにはさまざまオプションが用意されており、多彩な機能が利用できます。<br/>
 >
 > 検査が終了したら <出力先ディレクトリ>に検査結果のレポートが html 形式で格納されます。<br/>
 > その htmlファイルをブラウザで開いて検査結果が確認できます。
 >

[[第7章 CI用Pipelineの設定へ]](pipeline.md)
