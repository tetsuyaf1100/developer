## 第4章 JenkinsとGitHub Enterpriseの連携

本ガイドでは構成管理ツール 「GitHubEnterprise」とCIツール「Jenkins」を連携させることによってCI環境を構築していきます。<br/>
「GitHubEnterprise」と「Jenkins」の連携に必要な設定として「WebHookの設定」と「SSHの設定」を行います。
連携を行うことで「 GitHubEnterprise 」のリポジトリに行われたイベントを「Jenkins」へ通知し、そのイベントをトリガーに「Jenkins」のジョブを起動させることができます。<br/>

以下では「GitHubEnterprise」と「Jenkins」の連携に必要な「WebHookの設定」と「SSHの設定」の手順を紹介します。<br/>

--------------------------------------------------------------------------------------------------------------------------------
　<br/>

### 4-1.GitHub EnterpriseのJenkinsへのトリガー

本ガイドでは「 GitHub Enterprise 」のリポジトリに行われた「PullRequest」と「Merge」をトリガーとしてJenkinsのジョブを実行させます。<br/>
Jenkinsでは「PullRequest」で起動するジョブと「Merge」で起動するジョブを用意し、
次の項で紹介する WebHookの機能で「 GitHub Enterprise 」から「Jenkins」へ送られてくる情報を判断し、該当するジョブを実行します。<br/>
具体的なジョブは第7章で作成します。<br/>
ここではJenkinsの起動に「PullRequest」と「Merge」をトリガーとして利用することを押さえて下さい。<br/>



### 4-2. WebHookの設定 <a name="webhook"></a><br/>

WebhookとはPushやPullRequestなどのイベントによりGitHub Enterpriseのリポジトリに変化があったことを連携するURLへ通知する機能です。<br/>
Payloadというパラメータでイベントに関する詳細情報を渡すことができます。<br/>
連携先をJenkinsにすることによって、GitHub Enterpriseのイベント情報を契機(トリガー)にJenkinsのジョブを実行することが可能となります。<br/>
GitHub Enterpriseと連携先であるJenkinsの両方に設定が必要です。<br/>

-----------------------------------------------------------------------------------------------------------------

**■Jenkins 側での設定**<br/>
> Jenkins側での設定については、ジョブ作成時に設定が必要になります。

1.　認証トークンの設定
 - ジョブの[ 設定 ] → [ build triggers ] → [ リモートからビルド ] にチェックします。
 - チェック後、[ 認証トークン ] に任意のトークンを記述します。( 例: pullrequest )

![認証トークン](./image/WebHook1.png)

　<br/>

2.　Payload<br/>
「Payload 」とは WebHook の契機となったイベントの詳細情報が入っているパラメーターです。<br/>
Jenkins側では、このパラメータを受け取ることで、ジョブのトリガーとして利用することが可能になります。<br/>
さらに詳細情報を読み取ることで発生したイベントが「PullRequest」なのか「Merge」なのかを判別することも可能になります。<br/>
 - ジョブの[ 設定 ] → [ general ] → [ ビルドのパラメータ化 ] にチェックします。
 - チェック後、[ パラメータの追加 ] → [ 文字列 ] を選択します。
 - [名前]に "payload" と記述してください。
　<br/>

![buildのパラメータ化](./image/WebHook2.png)

**■GitHub Enterprise側での設定**<br/>

> GitHub Enterprise側では、連携先URLとWebhookを作動させるイベントを設定します。<br>
 - 対象のリポジトリの [ Settings ] → [ Hooks&Service ] を選択します。
 - [ Add webhook ]ボタンを押下します。
![Add webhookl](./image/WebHook3.png)
<br/>

下記設定画面に遷移したら赤①から③を設定します。<br/>

【Webhooks/Add Webhooks 設定画面】<br/>
![Add webhook2](./image/WebHook7.png)
　<br/>

1.　Payload URL 設定<br/>

上記【Webhooks/Add Webhooks 設定画面】の赤①の欄に以下を設定します。<br/>

http://[USER_ID]:[API_TOKEN]@[JENKINS_HOST]/job/[JOB_NAME]/buildWithParameters?token=[TOKEN_NAME]

```
Payload URL 設定
【USER_ID】：Jenkinsにログインするためのユーザ名
【API_TOKEN】：Jenkinsのアカウントごとに発行されるトークン(後述)
【JENKINS_HOST】：JenkinsのHOST名
【JOB_NAME】：WebHookで連携するJenkinsで作成したジョブ名
【TOKEN_NAME】：連携するJenkinsのジョブで設定した認証トークン

```
 例)<br/>
`http://admin:xxxxx@jenkins.example.com/job/sample/buildWithParameters?token=pullrequest`<br/>

>【API_TOKENの取得方法】<br>
>
>API TokenはJenkins側で取得します。<br/>
>Jenkinsのセキュリティ機能が有効になっている場合、WebHookを介してビルドを実行するには「ユーザーID」と「API Token」が必要になります。<br/>
>※API Tokenとはログイン時に用いる「パスワード」ではなく、アカウントごとに発行される32文字のランダムな英数字列です。<br>
>
>以下、取得手順
>
>　1. [ Jenkinsの管理 ] → [ ユーザーの管理 ] を選択します。
>![API Token](./image/WebHook4.png)
>　<br/>
>　
>　2. ユーザーID を選択し、[ 設定 ]マーク を押下します。
>![API Token](./image/WebHook5.png)
>　 <br/>
>　
>　3. [ APIトークンの表示 ] で取得することができます。
>![API Token](./image/WebHook6.png)
>　<br/>
>

2.　Content type 設定<br/>

前掲の【Webhooks/Add Webhooks 設定画面】の赤②で設定を行います。<br/>

"Content type"はどのような形式でPayloadを表現するかを決めます。 <br/>
選択肢に<br>
- application/json
- application/x-www-urlencoded

が用意されておりますが、Jenkinsで対応している「application/x-www-urlencoded」を指定します。<br>

![Content type](./image/webhook_contentType.jpg)
　<br/>



 3.　Which events would you like to trigger this webhook?<br/>

 前掲の【Webhooks/Add Webhooks 設定画面】の赤③で設定を行います。<br/>

  "Which events would you like to trigger this webhook?"ではWebHookを起動させるタイミングを指定できます。<br/>
  設定は任意で、選択肢として以下が用意されています。<br>

```
    選択肢の内容
    ・Just the push event.　→ push時のみWebHookを起動します。
    ・Send me everything.　→ 全てのイベントに対してWebHookを起動します。
    ・Let me select individual events.　→ 選択した項目に対してWebHookを起動します。
```

  本書ではpullrequest時のみWebHookを起動させるため、『Let me select individual events.』を選択し、PullRequestを選択します。<br/>

![Content type](./image/webhook_trigger.jpg)
　<br/>

  『Let me select individual events.』の選択肢は以下の通りです。<br/>
  今回は「Pull request」と「merge」でジョブを分けますので、「Pull request」にだけチェックをつけます。<br/>
  はじめからチェックがついている「Push」のチェックは外してください。<br/>
  ![GitHub WebHook ](./image/WebHook8.jpg)

　<br/>

### 4-3. SSHの設定 <a name="SSH"></a><br/>

JenkinsとGitHubEnterpriseを接続するために必要な設定です。<br/>
※ここでは、JenkinsにSSH接続するために必要な秘密鍵と公開鍵が作成されていることを前提としています。<br/>

**■ Jenkins の設定**<br/>
> Jenkins 側の設定については、ジョブ作成時にSSH用の秘密鍵を認証情報として設定する必要があります。<br/>
> ※設定が必要なジョブは、GitHubから資産を取得するジョブのみになります。<br/>
- [ ソースコード管理 ] → [ Git ] にチェックします。
- チェック後、[ リポジトリURL ] に連携したいGitHubのリモートリポジトリURLを入力します。
- [ 認証情報 ]にある[ 追加 ]を押下し、出力される[ Jenkins ]を選択します。<br/>

【ソースコード管理画面】<br/>
![認証トークン](./image/SSH3.png)
　<br/>

選択後、[ 認証情報の追加 ] 画面がポップアップします。<br/>

【認証情報の追加画面】<br/>
![Jenkins SSH](./image/SSH4.png)<br/>

以下の項目を設定します。<br/>

   - Domain<br>
　設定内容：グローバルドメイン(固定)<br/>
   - 種類<br>
　設定内容：SSHユーザ名と秘密鍵<br/>
   - スコープ<br>
　設定内容：グローバル<br>
　※詳細は選択肢の右にあるヘルプアイコンから確認してください。<br/>
   - ユーザー名<br>
　設定内容：Jenkinsがインストールされているサーバのユーザ名<br>
   - 秘密鍵<br>
　設定内容：３つの選択肢から秘密鍵の参照元を選びます。<br/>
　　・「Jenkinsマスター上の~/.sshから」<br/>
　　　　　→ Jenkinsマスター上にある.sshファイルに格納されている秘密鍵を参照します。<br/>
　　・「Jenkinsマスター上のファイルから」<br/>
　　　　　→ Jenkinsマスター上にあるファイル名を設定し、参照します。<br/>
　　・「直接入力」<br/>
　　　　　→ 直接、秘密鍵の情報を記述し、設定します。<br/>
　※本書では「直接入力」を選択します。<br/>

以上の項目を設定したら、一番下の左にある"追加"を押下し、設定完了です。<br/>


**■ GitHubEnterpriseの設定**<br/>
> GitHub側の設定については、GitHubの個人設定からSSH用の公開鍵を設定する必要があります。<br/>

 [ SSH keys ] の設定<br/>
 [ 右上のプロフィールアイコン ] → [ Settings ] → [ SSH & GPG keys ] を選択します。
![GitHub SSH](./image/SSH1.png)

　<br/>
[ New SSH Key ]ボタンを押下し、以下の項目を設定します。<br/>
   - Title<br/>
 　　設定内容：登録する SSH key の名称を任意で設定します。<br/>
   - Key<br/>
 　　設定内容：Jenkinsに接続するための公開鍵情報を設定します。<br/>
 ![ GitHub SSH ](./image/SSH2.png)
　<br/>
設定後、[ Add SSH key ] を押下し、設定完了です。
