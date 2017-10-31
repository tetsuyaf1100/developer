# 第6章 テストツールの導入

本ガイドの開発テストで使用するテストツールの導入手順と実行コマンドを示します。

テストツールは仮想サーバ（ CentOS 7 ）へ導入します。

実行コマンドは Jenkins のジョブ作成の際に利用しますので、Jenkins ユーザでコマンドが実行できるように導入してください。

本ガイドでは、Jenkins ユーザで導入作業を行います。

-----------------------------------------------------------------------------------------------

## 6-1.各種テストツール導入と実行コマンド

### Markdown ファイル構文チェックツール

参考：[ Markdownlint ](https://github.com/mivok/markdownlint)

Markdownlint は ruby 形式のため ruby の導入が必要です。

ruby の導入手順  

参考サイト
  - [ruby公式サイト](https://www.ruby-lang.org)
  - [rbenv公式リポジトリ](https://github.com/rbenv/rbenv)


```bash
# Jenkins ユーザで導入作業を行います。
# ruby のバージョン管理ツール rbenv を git より入手
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# ruby-build プラグインを追加
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# .bash_profile に rbenv のパスを追加
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

# ruby のインストールに必要なパッケージをインストール
sudo yum -y install bzip2 gcc openssl-devel readline-devel zlib-devel

# バージョン確認
rbenv --version

# インストールできる ruby のバージョン確認
rbenv install --list

# ruby をインストール
rbenv install {最新バージョン} （例：2.4.2）2017.10現在最新版

# インストールされている ruby バージョンリスト確認
rbenv versions

# バージョンを選択  ※インストールしたバージョンを選択して下さい。
rbenv global 2.4.2
```

### Markdownlint の導入手順

```bash
# Jenkins ユーザで導入作業を行います。
# gem は ruby と一緒に導入されたパッケージ管理ツールです。
gem install mdl
git clone https://github.com/mivok/markdownlint
cd markdownlint
gem install bundler
rake install

# テスト実施コマンド
mdl { チェックするファイル .md }
```

### html 構文チェックツール

参考：[ HTMLHint ](http://htmlhint.com/)

導入の前提として node のバージョンが v0.11.15 以上必要です。

node.js のバージョン確認
`node -v` または `nvm ls`

node.js のバージョン変更
`nvm use { バージョン名 }`

※node.js のインストールは[「2-3. Hexo導入手順」](ci-server.md)で実施しています。

```bash
# Jenkins ユーザで導入作業を行います。
npm install htmlhint -g

# テスト実施コマンド
cat { チェックするファイル.html } | htmlhint stdin

# またはチェックしたいファイルがあるディレクトリへ移動し、以下コマンドを実行
htmlhint
```

### アタックテスト（脆弱性検査）ツール

参考：[ Skipfish ](https://code.google.com/archive/p/skipfish/wikis/SkipfishDoc.wiki)

Skipfish は Google が開発した脆弱性検査ツールで、CUI 環境での利用になります。

検査対象の Webサイトに対しクローリングを行い、アクセス可能な URL を抽出し、それらに対しさまざまなパターンで問題の発生しそうな URL やリクエストを生成してアクセスすることで調査を行います。

調査結果は html ファイル形式のレポートで作成され、ブラウザで確認できるようになっています。

以下、CentOS 7 への導入手順です。

```bash
# Jenkins ユーザで導入作業を行います。
# opt ディレクトリに入ります
cd /opt

# Skipfish の tgz ファイルを wget で取得します。
# ダウンロードサイト https://code.google.com/archive/p/skipfish/downloads
# 推奨版 (featured)：skipfish-2.10b.tgz (（※2017/10 現在)
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/skipfish/skipfish-2.10b.tgz

# yum に必要なパッケージを追加します。
sudo yum install pcre-devel openssl-devel libidn-devel libidn2-devel

# Jenkins ユーザ配下に作業ディレクトリ(例：test-skipfish)を作成します。
mkdir /var/lib/jenkins/test-skipfish

# tgz ファイルをコピーします。
cp skipfish-2.10b.tgz /var/lib/jenkins/test-skipfish

# コピー先の作業ディレクトリで tgz ファイルを解凍します。
cd /var/lib/jenkins/test-skipfish
tar zxvf skipfish-2.10b.tgz

# 解凍され展開されたディレクトリ(例：skipfish-2.10b）に入ります。
cd skipfish-2.10b

# make コマンドでソースからプログラムをビルドします。
make
```

検査を行うには次のコマンドを実行します。

```bash
$ ./skipfish -o { 出力先ディレクトリ名 } { 検査対象サイト url }
```

なおSkipfishのコマンドにはさまざまオプションが用意されており、多彩な機能が利用できます。

検査が終了したら { 出力先ディレクトリ } に検査結果のレポートが html 形式で格納されます。

その html ファイルをブラウザで開いて検査結果が確認できます。

[[第7章 CI用Pipelineの設定へ]](pipeline.md)
