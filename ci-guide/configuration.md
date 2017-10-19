# 第4章 JenkinsとGitHub Enterpriseの連携

本ガイドでは構成管理ツール 「GitHub Enterprise」とCIツール「Jenkins」を連携させることによってCI環境を構築していきます。

「GitHub Enterprise」と「Jenkins」の連携に必要な設定として「WebHookの設定」と「SSHの設定」を行います。
連携を行うことで「 GitHub Enterprise 」のリポジトリに行われたイベントを「Jenkins」へ通知し、そのイベントをトリガーに「Jenkins」のジョブを起動させることができます。


以下では「GitHub Enterprise」と「Jenkins」の連携に必要な「WebHookの設定」と「SSHの設定」の手順を紹介します。

--------------------------------------------------------------------------------------------------------------------------------

## 4-1. GitHub EnterpriseのJenkinsへのトリガー

本ガイドでは「 GitHub Enterprise 」のリポジトリに行われた「PullRequest」と「Merge」をトリガーとしてJenkinsのジョブを実行させます。

Jenkinsでは「PullRequest」で起動するジョブと「Merge」で起動するジョブを用意し、
次の項で紹介する WebHookの機能で「 GitHub Enterprise 」から「Jenkins」へ送られてくる情報を判断し、該当するジョブを実行します。

具体的なジョブは第7章で作成します。

ここではJenkinsの起動に「PullRequest」と「Merge」をトリガーとして利用することをご確認下さい。

## 4-2. WebHookの設定

WebhookとはPushやPullRequestなどのイベントによりGitHub Enterpriseのリポジトリに変化があったことを連携するURLへ通知する機能です。

Payloadというパラメータでイベントに関する詳細情報を渡すことができます。

連携先をJenkinsにすることによって、GitHub Enterpriseのイベント情報を契機(トリガー)にJenkinsのジョブを実行することが可能となります。

GitHub Enterprise と連携先である Jenkins（画面およびK5上の仮想サーバ）、K5 IaaS サービスポータルでの設定が必要です。

-----------------------------------------------------------------------------------------------------------------

### Jenkins （画面）での設定

Jenkins 画面での設定については、ジョブ作成時に設定が必要になります。

以下、設定手順

1. 認証トークンの設定
  - WebHookで起動するジョブを作成します。
  - ジョブの[ 設定 ] → [ build triggers ] → [ リモートからビルド ] にチェックします。
  - チェック後、[ 認証トークン ] に任意のトークンを記述します。( 例: pullrequest )

  > ![認証トークン](./image/WebHook1.png)

2. Payload

  「Payload 」とは WebHook の契機となったイベントの詳細情報が入っているパラメーターです。

  Jenkins 側では、このパラメータを受け取ることで、ジョブのトリガーとして利用することが可能になります。

  さらに詳細情報を読み取ることで発生したイベントが「PullRequest」なのか「Merge」なのかを判別することも可能になります。

  - ジョブの[ 設定 ] → [ general ] → [ ビルドのパラメータ化 ] にチェックします。
  - チェック後、[ パラメータの追加 ] → [ 文字列 ] を選択します。
  - [名前]に "payload" と記述してください。

  > ![buildのパラメータ化](./image/WebHook2.png)

3. CSRFの設定を外す

Jenkins のグローバルセキュリティの設定で CSRF（クロスサイトリクエストフォージェリ）対策にチェックがある場合、Webhook が403エラーになります。

本ガイドでは手順の再現のため CSRF 対策チェックを外します。

Jenkins による CSRF 対策に関しては、Jenkins の公式サイト等でご確認下さい。

Jenkins の管理画面で設定を以下のように行います。

```
Jenkins の管理＞ グローバルセキュリティの設定＞ CSRF Protection

□ CSRF 対策 　←ここのチェックを外します。
```

> ![グローバルセキュリティの設定](./image/CSRF.jpg)

### Jenkins （仮想サーバ）での設定

Jenkins を導入したK5上の仮想サーバ(CentOS 7)での作業になります。

K5 の GitHub Enterprise から Jenkins サーバに対して Webhook を行なう場合、指定するポートには制限(80 or 443)があります。

Httpの場合では、Jenkinsのデフォルトポートは tcp8080、GitHub Enterprise は tcp80 となり、相違が生じます。

このため、GitHub Enterprise から tcp80 で送信されたリクエストを Jenkins の tcp8080 に転送するための処理（ポートフォワーディング）が必要になります。

具体的には、Jenkins を導入した仮想サーバOS（CentOS 7）に firewalld を導入し、ポートフォワーディングの設定を行います。 

以下、手順です。

------------------------------------------------------------------

1. firewalldのインストール

K5が提供するCentOS 7 のイメージには、デフォルトでfirewalldが導入されていません。

firewalld を導入してください。

```
#firewalldインストール
yum -y install firewalld

#firewalld起動
systemctl start firewalld

#firewalld自動起動設定
systemctl enable firewalld

#firewalld 状態確認
systemctl status firewalld
※ Active : active (running) になっていれば、起動成功です。
```

2. ポートフォワーディングの設定

導入した firewalld を利用して、ポートフォワーディングの設定を行います。

以下、tcp 80番ポートで受け取った通信を、tcp 8080番ポートへ転送する設定です。

```
# ポートフォワーディング
firewall-cmd --permanent --add-forward-port="port=80:proto=tcp:toport=8080"

# リロード
firewall-cmd --reload

# firewalld の設定確認
firewall-cmd --list-all
※「forward-ports: 」の項目にポートファワーディングの設定内容が表示されます。
例）forward-ports: port=80:proto=tcp:toport=8080:toaddr=

```

### K5 IaaS サービスポータルでの設定

Jenkinsを導入したK5上の仮想サーバを導入したネットワークの設定を変更します。

1. グローバルIP の付与

Jenkinsを導入した仮想サーバにグローバルIPを付与してください。

K5 IaaS サービスポータルのコンピュート＞仮想サーバ一覧からJenkinsを導入したサーバを選択し、
仮想サーバ詳細画面のポートのアクションボタンでグローバルIP割当を押下すれば設定ができます。

詳しくは、[IaaS 機能説明書](https://k5-doc.jp-east-1.paas.cloud.global.fujitsu.com/doc/jp/iaas/document/function-manual/index.html)をご覧ください。

2. ポートの開放

Webhookのためにセキュリティグループ、およびファイアウォールにルールを追加してください。

詳しくは、[IaaS 機能説明書](https://k5-doc.jp-east-1.paas.cloud.global.fujitsu.com/doc/jp/iaas/document/function-manual/index.html)をご覧ください。

以下、参考として前項までに設定した GitHub Enterprise から tcp80 で送信されたリクエストを Jenkins の tcp8080 にポートフォワーディングする場合に必要なルール追加設定の例です。

仮想サーバのセキュリティグループには、tcp80とtcp8080のポートを開放するルールを追加してください。

Webhookのために必要なセキュリティグループのルール例

方向     | IPバージョン | プロトコル | ポート範囲  | 宛先
:------- | :------------| :----------| :---------- |  :---------
ingress  | IPv4         | tcp        | 80 - 80     | 0.0.0.0/0
ingress  | IPv4         | tcp        | 8080 - 8080 | {クライアントIPプール}

K5上のネットワークにファイアウォールを設定している方は、tcp80のポートを開放するルールを追加してください。

参考：Webhookのために必要なファイアウォールルール例

プロトコル     | 送信元IP [ポート]                    | 宛先IP [ポート] 
:------------- | :------------------------------------| :------------------------------
tcp            |  (any または Github EnterpriseのIP)  | {仮想サーバのグローバルIP} [80]

JenkinsサーバにグローバルIPを付与し、必要なポートを開放した以降は、Jenkinsのサービス画面にはグローバルIPからアクセスできます。

仮想サーバIP : 8080 →　グローバルIP

（例　192.168.1.13:8080　→　133.162.153.149）


### GitHub Enterprise側での設定

GitHub Enterprise側では、連携先URLとWebhookを作動させるイベントを設定します。

以下、設定手順

1. Webhook設定画面の表示
  - 対象のリポジトリの [ Settings ] → [ Hooks&Service ] を選択します。
  - [ Add webhook ]ボタンを押下します。

  > ![Add webhookl](./image/WebHook3.png)

  下記設定画面に遷移したら赤①から③を設定します。

  【Webhooks/Add Webhooks 設定画面】
  > ![Add webhook2](./image/WebHook7.png)

2.  Payload URL 設定

  上記【Webhooks/Add Webhooks 設定画面】の赤①の欄に以下を設定します。

Payload URL 設定

http://[USER_ID]:[API_TOKEN]@[JENKINS_HOST]/job/[JOB_NAME]/buildWithParameters?token=[TOKEN_NAME]

次の表を参考に上記 url の各項目に値を入れて Payload URL を作成してください。

設定項目      | 設定内容           
:-----------  | :------------------------------------
[USER_ID]     |  Jenkinsにログインするためのユーザ名　（例：admin）
[API_TOKEN]   |  Jenkinsのアカウントごとに発行されるトークン(後述)　（例：xxxxx）
[JENKINS_HOST]|  {仮想サーバのグローバルIP}（JenkinsのHOST名)　（例：133.162.153.149）
[JOB_NAME]    |  WebHookで連携するJenkinsで作成したジョブ名　（例：sample）
[TOKEN_NAME]  |  連携するJenkinsのジョブで設定した認証トークン　（例：pullrequest）

 
  `例) http://admin:xxxxx@133.162.153.149/job/sample/buildWithParameters?token=pullrequest`

   【API_TOKENの取得方法】

   API TokenはJenkins（画面）で取得します。

   ※API Tokenとはログイン時に用いる「パスワード」ではなく、アカウントごとに発行される32文字のランダムな英数字列です。

   以下、Jenkins（画面）にて取得手順

   ① [ Jenkinsの管理 ] → [ ユーザーの管理 ] を選択します。
   > ![API Token](./image/WebHook4.png)

   ② ユーザーID を選択し、[ 設定 ]マーク を押下します。
   > ![API Token](./image/WebHook5.png)

   ③ [ APIトークンの表示 ] で取得することができます。
   > ![API Token](./image/WebHook6.png)

表示された API Token を Payload URL 設定 で使用します。



3. Content type 設定

  前掲の【Webhooks/Add Webhooks 設定画面】の赤②で設定を行います。

  "Content type"はどのような形式でPayloadを表現するかを決めます。

  選択肢に
  - application/json
  - application/x-www-urlencoded

  が用意されておりますが、Jenkinsで対応している「application/x-www-urlencoded」を指定します。<br>

  > ![Content type](./image/webhook_contentType.jpg)


4.  Which events would you like to trigger this webhook?

  前掲の【Webhooks/Add Webhooks 設定画面】の赤③で設定を行います。

  "Which events would you like to trigger this webhook?"ではWebHookを起動させるタイミングを指定できます。

  設定は任意で、選択肢として以下が用意されています。

  - 「Just the push event.」

      push時のみWebHookを起動します。

  - 「Send me everything.」

      全てのイベントに対してWebHookを起動します。

  - 「Let me select individual events.」

      選択した項目に対してWebHookを起動します。

  本書ではpullrequest時のみWebHookを起動させるため、『Let me select individual events.』を選択し、PullRequestを選択します。

  > ![Content type](./image/webhook_trigger.jpg)

  『Let me select individual events.』の選択肢は以下の通りです。

  今回は「Pull request」と「merge」でジョブを分けますので、「Pull request」にだけチェックをつけます。

  はじめからチェックがついている「Push」のチェックは外してください。

  > ![GitHub WebHook ](./image/WebHook8.png)
  
以上で、GitHub Enterprise と Jenkins の Webhook による連携が可能となります。



## 4-3. SSHの設定

JenkinsとGitHub Enterpriseを接続するために必要な設定です。

JenkinsにSSH接続するために必要な SSH Keys（秘密鍵と公開鍵）を準備してください。

### 参考：SSH Keys 作成例

Jenkinsを導入した仮想サーバ CentOS 7 で作業を行います。

Jenkinsユーザで作業を行います。以下、手順です。

```
# SSH Keys を格納するディレクトリを作成
mkdir .ssh

# .ssh の所有者をJenkinsに変更
sudo chown jenkins .ssh

# SSH Keys を作成
sudo -u jenkins -H ssh-keygen -t rsa -C "任意のコメント"

※以上で .ssh ディレクトリ内に SSH Keysが作成されます。

# SSH Keys　確認
ls .ssh
※３つのファイルが作成されています。
id_rsa（秘密鍵） id_rsa.pub（公開鍵） known_hosts（接続サーバのSSHサーバ証明書記録用ファイル）

```

上記手順で作成したid_rsa（秘密鍵） id_rsa.pub（公開鍵）を`cat` コマンドで開き、中身をコピーして以下の設定で使用します。



### Jenkins の設定

Jenkins 側では、ジョブ作成時にSSH用の秘密鍵を認証情報として設定する必要があります。

※設定が必要なジョブは、GitHubから資産を取得するジョブのみになります。

以下、設定手順

- [ ソースコード管理 ] → [ Git ] にチェックします。
- チェック後、[ リポジトリURL ] に連携したいGitHubのリモートリポジトリURLを入力します。

  例）git@git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com:ユーザ名/リポジトリ名.git

- [ 認証情報 ]にある[ 追加 ]を押下し、出力される[ Jenkins ]を選択します。

【ソースコード管理画面】

> ![認証トークン](./image/SSH3.png)

選択後、[ 認証情報の追加 ] 画面がポップアップします。

【認証情報の追加画面】

> ![Jenkins SSH](./image/SSH4.png)

以下の項目を設定します。
- Domain<br>

  設定内容：グローバルドメイン (このまま)

- 種類<br>
  設定内容：SSHユーザ名と秘密鍵

- スコープ<br>
  設定内容：グローバル<br>
  ※詳細は選択肢の右にあるヘルプアイコンから確認してください。

- ユーザー名<br>
  設定内容：Jenkinsがインストールされているサーバのユーザ名　（例：Jenkins）<br>

- 秘密鍵<br>
  設定内容：３つの選択肢から秘密鍵の参照元を選びます。

  - 「Jenkinsマスター上の~/.sshから」

    Jenkinsマスター上にある.sshファイルに格納されている秘密鍵を参照します。

  - 「Jenkinsマスター上のファイルから」

    Jenkinsマスター上にあるファイル名を設定し、参照します。

  - 「直接入力」

    id_rsa（秘密鍵）の中身をコピーし、設定します。

  ※本書では「直接入力」を選択します。

以上の項目を設定したら、一番下の左にある"追加"を押下し、設定完了です。


### GitHub Enterpriseの設定

GitHub側では、GitHubの個人設定からSSH用の公開鍵を設定する必要があります。

以下、設定手順

 [ 右上のプロフィールアイコン ] → [ Settings ] → [ SSH & GPG keys ] を選択します。

> ![GitHub SSH](./image/SSH1.png)

[ New SSH Key ]ボタンを押下し、以下の項目を設定します。

- Title

  設定内容：登録する SSH key の名称を任意で設定します。

- Key

  設定内容：id_rsa.pub（公開鍵）の中身をコピーし設定します。

> ![ GitHub SSH ](./image/SSH2.png)

設定後、[ Add SSH key ] を押下し、設定完了です。

[[第5章 CFの説明へ]](cf.md)
