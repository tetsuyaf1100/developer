## 第5章 CF環境構築<br/>

本ガイドではテスト用サーバ、公開用サーバ としてK5が提供するサービス「 CF 」を利用します。<br/>
「 CF 」はオープンソースの「Cloud Foundry」をベースとしたアプリケーション実行環境サービスです。<br/>
ご利用内容等の詳細は公式サイト[「FUJITSU Cloud Service K5　CF」](http://jp.fujitsu.com/solutions/cloud/k5/function/paas/cf/ )をご覧ください。<br/>

-----------------------------------------------------------------------------------------------------

### 5-1. CF導入方法（ビルドパック）および環境設定方法<br/>

[「 CF 使用手順チュートリアル 」](https://cf-docs.jp-east-1.paas.cloud.global.fujitsu.com/ja/manual/tut/tut/topics/preface.html)をご覧ください。<br/>

### 5-2. CFアップロード手順<br/>

CFへ資産をアップロードする手順を説明します。<br/>
本ガイドで構築するCIではJenkinsによって開発資産をCFへデプロイします。その基本となる手順です。<br/>
CFコマンドに関しては[「リファレンス CF コマンド」](https://cf-docs.jp-east-1.paas.cloud.global.fujitsu.com/ja/manual/ref/ref/topics/c-cf-cli.html)をご参考下さい。<br/>

仮想マシンCentOS7での作業です。<br/>

```
#アップロードするファイルがあるディレクトリへ移動
cd <ディレクトリ名>

#(必要に応じて)プロキシの設定
set http_proxy="<ユーザ名>:<パスワード>@<プロキシのアドレス>:<プロキシのポート>/"
set https_proxy="<ユーザ名>:<パスワード>@<プロキシのアドレス>:<プロキシのポート>/"

#CFエンドポイントを設定
cf api --skip-ssl-validation <APIエンドポイント>

#ログイン
cf login -u <ユーザ名>@<契約番号> -o <契約番号> -s <スペース名>
(パスワードを入力)

# アップロード
cf push <APPLICATION_NAME>
※アップロードされたファイルは表示されたURLで確認できます。

#ログの表示
cf logs <APPLICATION_NAME> --<スペース名>

#ログアウト
cf logout

```

[[第6章 テストツールの導入へ]](test-tools.md)
