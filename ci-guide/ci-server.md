# 第2章　CIサーバ環境構築

本章では、前章で導入した仮想サーバ（ CentOS 7 ）へ CI （継続的インテグレーション）ツールとして [「 Jenkins 」](https://jenkins.io/ )と、
コンテンツ作成ツールとして静的ページジェネレータである [「 Hexo 」](https://hexo.io/)を導入し、CI サーバの構築を行います。

## 2-1. Jenkins 導入手順

### Jenkins のインストール

CIツール 「 Jenkins 」 を仮想サーバ（ CentOS 7 ）へ導入します。

[「 Jenkins 」](https://jenkins.io/)の公式サイトから「 Red Hat/Fedora/CentOS 」パッケージの Jenkins をインストールします。

以下の手順は root ユーザで操作します。

#### JDK の導入

Jenkins は Java で実装されているため JDK を導入します。

最新バージョンの Jenkins では Java7 以上が必要です。

```bash
yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel
```

#### yum リポジトリへ Jenkins の情報を追加

情報の追加には wget コマンドを使用するため、 wget コマンドが導入されていない場合は` yum install wget`でインストールします。

```bash
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import https://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
```

#### Jenkins をインストール

```bash
yum install jenkins
```

#### 使用ポート変更

Jenkins はデフォルトで8080ポートを使用します。

ポートを変更する場合は次の設定を行います。

```bash
vi /etc/sysconfig/jenkins

-----省略-----
JENKINS_PORT="設定したいポート番号"
-----省略-----
```

#### 使用するポートをセキュリティグループおよびファイアウォールに設定

K5 IaaS サービスポータルで仮想サーバのセキュリティグループおよび仮想ネットワークのファイアウォールに Jenkins のポートを許可するルールを追加します。

詳しくは以下をご覧下さい。

- [IaaS 機能説明書 セキュリティグループ機能](https://k5-doc.jp-east-1.paas.cloud.global.fujitsu.com/doc/jp/iaas/document/function-manual/index.html#concept/concept_network_securitygroup.html)
- [IaaS 機能説明書 ファイアーウォールサービス](https://k5-doc.jp-east-1.paas.cloud.global.fujitsu.com/doc/jp/iaas/document/function-manual/index.html#concept/concept_network_fwaas.html)

#### Jenkins を起動

```bash
# 起動
systemctl start jenkins

# 停止
systemctl stop jenkins

# システム起動時に自動起動させる設定
chkconfig jenkins on
```

#### Webブラウザで Jenkins の起動確認

`http://{仮想サーバのIPアドレス}:{設定したポート番号}`

`例）http://192.168.1.13:8080`


【 図1 Jenkins 初期画面 】
  ![Jenkins](./image/jenkins.jpg)

初回起動時は管理者が起動していることを確認するため、管理者パスワード「 Administrator password 」の入力を求められます。（ 図１赤枠部分 ）

管理者パスワード「 Administrator password 」は、Jenkins をインストールした仮想サーバで確認できます。

`cat /var/lib/jenkins/secrets/initialAdminPassword`

管理者パスワードを入力すると、「図2 Customize Jenkins 」画面が表示されます。

【 図2 Customize Jenkins 画面 】

  ![Jenkins02](./image/jenkins_plugin.jpg)

ここでは Jenkins を拡張・カスタマイズするプラグインのインストールが選択できます。

2つ選択肢が提示されますのでお選びください。

- 「 Install suggested plugins 」（推奨プラグインの一括インストール）
- 「 Select plugins to install 」（プラグインを選択してインストール）

選択してインストールしたいプラグインがなければ、「 Install suggested plugins 」（推奨プラグインの一括インストール）を選択します。

「 Install suggested plugins 」を押下しましたら以下のように自動的にプラグインがインストールされます。

【 図3 Plugin Install 画面 】

  ![Jenkins03](./image/jenkins_pluginInstall.jpg)

プラグインのインストールが完了すると、「図4 管理者ユーザーアカウント設定画面」が表示されます。

【 図4 管理者ユーザーアカウント設定画面 】

  ![Jenkins04](./image/jenkins_user.jpg)

必要な項目を入力して ［ Save and Finish ］ ボタンを押します。

[ Continue as admin ] を選択した場合は、

管理者アカウントのユーザー名は "admin"、

パスワードは初回起動時に入力したものになります。

初期設定が問題なく準備できましたら「図5 準備完了画面」が表示されます。

【 図5 準備完了画面 】

  ![Jenkins05](./image/jenkins_ready.jpg)

[ Start using Jenkins ]  ボタンを押下することで「 Jenkins オープニング画面」に移動し、Jenkins が利用可能になります。

【 図6 Jenkins オープニング画面 】

  ![Jenkins06](./image/jenkins_opening.jpg)

### 仮想サーバの Jenkins ユーザについて

インストールすると自動的に jenkins グループと jenkins ユーザが作成されます。

**Jenkins の構成**

ディレクトリ                         | パス
:----------------------------------- | :------------------------------------------
JENKINS_HOME                         | /var/lib/jenkins
設定ファイル                         | /etc/sysconfig/jenkins
キャッシュフォルダ                   | /var/cache/jenkins
ログフォルダ                         | /var/log/jenkins

いずれのフォルダも 【 ユーザ： jenkins 】、 【 グループ： jenkins 】 となっています。

### Jenkins ユーザの権限設定の方法

CI 環境を構築し、導入した各種ツールを Jenkins から操作する場合、仮想 OS の Jenkins ユーザに権限を与える、パスを通すなどの作業が必要になります。

本ガイドでは Jenkins ユーザに sudo コマンドを設定し、以下手順を進めます。

権限やパスの設定に際しては必ず開発グループなどのセキュリティ規定を考慮し、ご判断ください。

-------------------------------------------------------------------------------------------------------------------------------------

【 例 】 ログインシェルの変更、su コマンドの設定

Jenkins ユーザのログインシェルはデフォルトでは /bin/false に設定されています。

ここを変更することによって su コマンドで Jenkins ユーザへの切り替えが可能になります。

su コマンドでは「 su root を実行できるユーザ間で root のパスワードを共有することになる」

「 su 実行後のコマンドの実行履歴がログに残らない」などセキュリティ面に懸念がありますのでご注意ください。

```bash
# ユーザの確認
cat /etc/passwd | grep jenkins
jenkins:x:996:994:Jenkins Automation Server:/var/lib/jenkins:/bin/false

# ログインシェル /bin/false　→　/bin/bash へ変更
chsh -s /bin/bash jenkins
jenkins のシェルを変更します。
シェルを変更しました。

# もう一度確認すると /bin/bash に変更されているのがわかります。
cat /etc/passwd | grep jenkins
jenkins:x:996:994:Jenkins Automation Server:/var/lib/jenkins:/bin/bash

# 以上で su コマンドで jenkins ユーザへ切り替わります。
su - jenkins
[Jenkinsユーザ名]$
```

【 例 】 sudo コマンド設定

sudo コマンドでは、あるユーザが別のユーザとしてコマンドを実行できるようになります。

su コマンドではできなかった特定のコマンド単位で権限を制限することも可能です。

セキュリティ面では su よりも sudo の方が強化されていますが、ログイン可能なユーザは root 権限を持つことになりますので、設定に際してはご注意ください。

```bash
# root より設定を行います。
# Jenkins ユーザを wheel グループに追加します。
usermod -aG wheel jenkins

# visudo により wheel グループの権限確認。コメントアウトされていれば「#」を外します。
visudo
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

# sudoの実行をパスワードなしで許可する場合は同様に「#」を外します。
## Same thing without a password
%wheel        ALL=(ALL)       NOPASSWD: ALL

# Jenkins ユーザでログインし sudo が可能か確認。
[jenkinsユーザ]$sudo whoami
root

```
以上で sudo コマンドが利用可能になり、Jenkins ユーザから root 権限が必要なコマンドが実行できるようになります。

sudo での PATH の引継ぎは `/etc/sudoers` の設定を `visudo` コマンドで変更してください。



## 2-2. Jenkins の操作画面について

### ジョブ作成手順

Jenkins 上で実行される処理を「ジョブ」と呼びます。

Jenkins を利用して CI 環境を構築するには各種テストやデプロイなどの「ジョブ」を作成していきます。

ここでは基本的な操作のみを紹介します。具体的なジョブの制作例は第7章で紹介します。

以下では、動作確認のため「 test-job 」という名称のジョブを作成します。

1. トップページ [ 新規ジョブ作成 ] 押下

  ![Jenkins07](./image/newJob_jenkins.jpg)

2. 「 Enter an item name 」欄にジョブ名「 test-job 」を入力し、「フリースタイルプロジェクトのビルド」を選択し、  
[ OK ] ボタンを押下。

![Jenkins08](./image/freeStyle_jenkins.jpg)

3. 「設定画面」に遷移したら「ビルド」の「ビルド手順の追加」から「シェルの実行」を選択。

![Jenkins09](./image/build_jenkins.jpg)

4. 実施したい処理のシェルスクリプトを記述します。

ここでは 「 Hello! Mr. Jenkins! 」 と標準出力させる処理を記述します。

「保存」ボタンを押下すればジョブの完成です。

![Jenkins10](./image/sh_jenkins.jpg)

5. 完成したジョブ「 test-job 」を実行します。

「ビルド実行」を押下すると「ビルド履歴」が表示されます。

ビルドが成功していれば青い丸とともに履歴が表示されます。

![Jenkins11](./image/exe_jenkins.jpg)

6. 確認のためコンソール画面を表示します。

先程の「ビルド履歴」から確認したいビルドの「# 番号」を選び、押下します。

画面遷移後、左側のメニューの「コンソール出力」を押下すればジョブの結果が表示されます。

![Jenkins12](./image/console_jenkins.jpg)

以上がジョブ作成の基本です。

### Pipeline 作成手順

「 Pipeline 」とは、各ジョブをつなげ、自動で処理（ステップ）を実行する機能です。Jenkins 2.0以降では標準装備されています。

Pipeline ではビルドやテストなど実行したい処理（ステップ）を「ステージ」ごとに定義することが可能であり、
各ステージの管理が容易に行えます。さらに開発・テストの進捗にあわせてステージの増減や順番の変更も可能です。

Jenkins を利用してビルド→テスト→デプロイなどの流れを自動化する場合、「 Pipeline 」機能が活用できます。

ここでは基本的な設定のみを紹介します。具体的な「 Pipeline 」の制作例は第7章で紹介します。

動作環境

- jenkins2.0 以上
- java SE 7 以上
- Pipeline Plugin ( jenkins2.0では標準装備 )

手順

[ 新規ジョブの作成 ] → 「 Enter an item name 」欄にジョブ名 → [ パイプライン ]を選択 → [ OK ]

![Jenkins13](./image/pipeline01_jenkins.jpg)

画面遷移後、ジョブの詳細設定画面で「パイプライン」エリアの「 Script 」欄にスクリプトを記述します。

【 Pipeline 設定画面】

![Jenkins14](./image/pipeline02_jenkins.jpg)

**スクリプト記述の基本形**

   Pipeline では、ステージごとに処理（ステップ）を分け、それらを段階的に実行することが可能です。
   
   基本的なスクリプトの記述例が以下になります。

  ```js
  node {
    stage('ステージ名'){
      このステージで実行する処理を記述
      }
    stage('ステージ名'){
      このステージで実行する処理記述
      }
    stage('ステージ名'){
      このステージで実行する処理記述
      }
    ･･･省略･･･
  }
  ```

また、Pipeline 設定画面の下部にある「 Pipeline Syntax 」を押下するとサンプルコードやリファレンスを参照することができます。

【Pipeline Syntax 画面】

![Jenkins15](./image/pipelineSyntax.jpg)

Jenkinsの公式サイトに[ Pipeline Steps Reference ](https://jenkins.io/doc/pipeline/steps/)が掲載されていますのでご参考ください。

以下、簡単な Pipeline を作成して実行します。

Pipeline 名は「 test-pipeline 」とします。

実行する処理は Stage01で「 Hello! Mr.Jenkins. 」、Stage02で「 Bye! Mr.Jenkins. 」と標準出力します。

```js
node {
    stage('stage01'){
        sh 'echo "Hello! Mr.Jenkins."'
    }
    stage('stage02'){
        sh 'echo "Bye! Mr.Jenkins."'
    }
}
```

上記のスクリプトを 【 Pipeline 設定画面 】の「パイプライン」-「 Script 」欄に記述し、設定を保存したら、ビルドを実行します。

Pipeline が上手く実行されれば下図のような実行結果が表示されます。

【 Pipeline 実行結果画面】
![Jenkins16](./image/exe_pipeline.jpg)

各ジョブの標準出力結果は前述の「コンソール画面」でご確認ください。

### プラグイン機能

Jenkins ではプラグインにより機能を拡張することが出来るのが大きな特徴です。

豊富なプラグインが用意されており、Jenkins の管理画面からプラグインを検索し、インストールすることで簡単にプラグインを導入できます。

**プラグイン導入手順**

`トップ画面の「Jenkinsの管理」→「プラグインの管理」→「利用可能」から 利用したいプラグインを選択 `

※Jenkins のプラグインには、特定のプラグインを利用するために他のプラグインを導入する必要がある場合があります。プラグインの依存関係に注意してください。

![Jenkins17](./image/plugin_jenkins.jpg)

本ガイドで必要となるプラグイン

- [ Git Plugin ](https://wiki.jenkins.io/display/JENKINS/Git+Plugin)  
  インストール後、「GitHub Enterprise」と連携したJenkinsのジョブが作成可能になります。 

- [ SSH Agent Plugin ](https://jenkins.io/doc/pipeline/steps/ssh-agent/)  
  SSH鍵認証を行えるようになります。  

なお、「プラグインの管理」画面で「インストール済み」タブを選択すれば、既に導入済みの プラグイン が確認できます。

初期画面ではAから始まる名称のプラグインの一覧が表示されます。

画面右上の [ フィルター ] 欄に検索したいプラグイン名を記入し検索することも可能です。

![Jenkins18](./image/plugin_check.jpg)

### メール機能

Jenkins ではビルドの実行結果をメールで通知することができます。

基本的な「 E-mail 通知」機能では、ビルド失敗時にのみメールが送信される設定ですが、
メール機能を拡張するプラグイン「 Email Extension Plugin 」を導入すれば、「拡張E-mail通知」の設定が可能になります。

ビルド失敗時だけでなく成功時にもメールを送信することができ、ビルドの実行状況に応じて送信内容を変更するなどのカスタマイズが可能になります。

#### 基本的なメール設定

##### SMTPメールサーバーの設定

`トップ画面「Jenkinsの管理」→「システムの設定」→「E-mail 通知」`

SMTPサーバーが用意できない場合は Gmail の SMTP サーバが利用できます。

以下は Gmail の SMTP サーバを利用した設定です。

設定項目                  | 設定値
:------------------------ | :------------------------
SMTPサーバー              |   smtp.gmail.com
E-mailのサフィックス      |   @gmail.com
SMTP認証                  |   チェックを入れます
ユーザ名                  |   Gmailのアカウント(xxx@gmail.com)
パスワード                |   Gmailのパスワード
SSL                       |   チェックを入れます
SMTPポート                |   465(SMTP over SSL) または 587(SMTP TLS/STARTTLS）
返信先アドレス            |   必要にあわせて記入
文字セット                |   UTF-8
メールを送信して設定を確認|   任意

【設定例 画像】

![メール設定01](./image/mail.jpg)

**各ジョブでの設定**

メール通知を設定したいジョブの[ 設定画面 ] → [ ビルド後の処理 ]にある[ ビルド後の処理の追加 ]を押下し、プルダウンメニューから[ E-mail通知 ]を選択します。

以下の画面が表示されますので、宛先にアドレスを記入することでメールがビルド失敗時に送信されるようになります。

![メール設定02](./image/email_job.jpg)

##### 拡張 E-mail 通知の設定

設定場所は `トップ画面「 Jenkins の管理」→「システムの設定」→「拡張 E-mail 通知」`

「拡張 E-mail 通知」では様々な設定が可能であり、設定項目も数多く用意されています。

本ガイドでは、最低限必要な項目の紹介のみ行います。

設定項目                        | 設定する内容
:------------------------------ | :------------------------------
SMTPサーバー                    | 送信に利用するSMTPサーバを設定
デフォルトE-mailのサフィックス  | @以降のデフォルト値を設定
デフォルトコンテンツ形式        | プレーンテキスト形式かhtmlメール形式か選択
Default Recipients              | 送信先メールアドレス
デフォルトサブジェクト          | デフォルトのメールタイトルを設定
デフォルトコンテンツ            | デフォルトのメールの本文を設定

以下は Gmail の SMTP サーバを利用した設定です。

【拡張 E-mail 通知 設定例 画像】

![拡張E-mail](./image/mail01.jpg)
![拡張E-mail](./image/mail02.jpg)
![拡張E-mail](./image/mail03.jpg)

上記設定例では `${PROJECT_NAME}` などのトークンを利用して記述しています。

設定項目の最後にある「トークンリファレンス」のヒントを押下すると利用可能なトークンの一覧が表示されます。

適宜参考にしてください。

【トークンリファレンス 画像】

![mail_token](./image/mail_token.jpg)

**各ジョブでの設定**

メール通知を設定したいジョブの [ 設定画面 ] → [ ビルド後の処理 ]にある[ ビルド後の処理の追加 ]を押下し、プルダウンメニューから[ E-mail通知 ]を選択します。

ジョブでの設定内容はシステムの設定で行ったものとほぼ同じです。また、システムで設定した項目を引き継ぐことも、あるいは個別に変更することも可能です。

参考例は第7章でご紹介します。



## 2-3. Hexo 導入手順

本ガイドでは、静的ページジェネレータ [「 Hexo 」](https://hexo.io/)を利用した開発を想定しています。

### Hexo 環境の導入手順

Hexo を導入する仮想サーバ（ CentOS 7 ）で作業を行います。

Hexo は Node で作成されているため Node.js の導入が必要となります。

参考サイト  
- [node.js 公式](https://nodejs.org)
- [nvm 公式リポジトリ](https://github.com/creationix/nvm)

Node.js 導入手順  

```bash
# node.js のバージョン管理ツール nvm を git から取得します。
yum -y install git
git clone https://github.com/creationix/nvm.git .nvm
source ~/.nvm/nvm.sh

# インストール可能な node.js のバージョンを確認
nvm ls-remote

# node.js の導入
nvm install {バージョン}　
※例：v6.11.4（ 2017.10現在 最新安定版（ LTS ））
※本ガイドでは導入の前提として node のバージョンが v0.11.15 以上必要です。

# node が正しく導入されたか確認します。
node -v

# nvm の設定
# デフォルトのバージョンを設定します。
nvm alias default {バージョン}

# nvm コマンドが実行できるように設定します。
vi ~/.bash_profile

if [[ -s ~/.nvm/nvm.sh ]];
 then source ~/.nvm/nvm.sh
fi

```

Hexo 導入手順

```bash
# Node.js と一緒にインストールされたパッケージマネージャ npm を利用して hexo を導入します。
  npm install hexo-cli -g

# Hexo の初期化。必要なファイル/フォルダが生成されます。
  hexo init [ Hexo作業用ディレクトリ名 ]
  cd [ ディレクトリ名 ]

# npm モジュールをインストールします。
  npm install

# Hexo サーバを起動しプレビューを確認します。
  hexo server
  INFO  Hexo is running at http://0.0.0.0:4000/. Press Ctrl+C to stop.

```
  INFO にある` http://localhost:4000/ ` にアクセスするとプレビューが表示されます。

  （プレビューの確認のためには4000番ポートを開放する必要があります。）


 以上で「 Hexo 」作業フォルダが準備できました。



### Hexo 記事の作成と HTML の生成

 Hexo は Markdown 形式のファイルから HTMLファイル を作成します。

 Markdown 形式のファイルも Hexo で作成でき、新しい記事を追加していくことができます。

 ここでは「 Hello Hexo 」というタイトルで記事を作成していきます。

 Hexo を導入したディレクトリで次のコマンドを実行します。

 ` hexo new post  "Hello Hexo" `

 Hexo を導入したディレクトリ配下に` /source/_posts/Hello-Hexo.md ` が作成されます。

作成された Markdown ファイルの中は以下のようになっています。

```bash
source/_posts/Hello-Hexo.md

title: "Hello Hexo"
date: 2017-06-30 12:03:08
tags:
---

ここ以降は空欄になっており、本文記入欄になります。

Markdown 形式で記載します。

例：

# Hello Hexo !


```

記事の作成が完了したら Markdown 形式ファイルから HTML ファイルを作成します。

` hexo generate ` コマンドで htmlファイルが作成され、publicフォルダ以下に格納されます。

以上で「 Hexo 」に新たな記事が追加されました。<br/>

 【参考： Hexo画面 】

  ![Hexo](./image/hexo.jpg)

### その他の Hexo の使い方 

#### テーマ（ theme ）の変更

Hexo ではテーマの変更も容易に行えます。

以下、テーマ変更手順です。

   1. Hexo 公式サイトの<a href="https://hexo.io/themes/">「 Themes 」</a>より好きなテーマを選びます。
   
   2. 選択したテーマのタイトルの Github ページからクローンを行います。  
      - Hexo を導入したディレクトリ配下の themes ディレクトリがクローン先です。
      - 例：テーマ 「 Clean-blog 」 を themes ディレクトリへクローン
      - `git clone https://github.com/klugjo/hexo-theme-clean-blog.git themes/clean-blog`
      
   3. Hexoを導入したディレクトリ配下にある 「 _config.yml 」 を修正します。  
      - デフォルトでは `theme: landscape` となっている部分を `theme: テーマ名` に変更します。
      - 例：`theme: clean-blog`

以上でテーマが変更できます。

【参考： Hexo画面 テーマ変更 】

  ![Hexoテーマの変更](./image/hexo_theme.jpg)

[[第3章 GitHub Enterprise環境構築へ]](github-enterprise.md)
