## 第2章　CIサーバ環境構築

本章では、前章で導入した仮想サーバ（CentOS7）へCI（継続的インテグレーション）ツールとして [「 Jenkins 」](https://jenkins.io/ )を導入し、
さらにコンテンツ作成ツールである静的ページジェネレータ [「 Hexo 」](https://hexo.io/)の導入も行って、CIサーバの構築を行います。<br>

 ※なお、本書ではCentOS7でのご利用を前提に説明します。<br/>
 　Ubuntu などの Debian 系では、インストールの際は yum コマンドではなく apt-get になります。<br/>
 　またCentOSでは最新バージョンCentOS7とCentOS6以前の旧バージョンではコマンドが異なりますのでご注意下さい。<br/>

------------------------------------------------------------------------------------------------------

### 2-1. Jenkins導入手順

#### Jenkinsのインストール<br/>

CIツール 「 Jenkins 」 を仮想サーバ(CentOS7)へ導入します。<br/>
[「 Jenkins 」](https://jenkins.io/)の公式サイトから「Red Hat/Fedora/CentOS」パッケージのJenkinsをインストールします。<br/>
以下の手順はrootユーザーで操作します。

1.JDKの導入<br/>
   JenkinsはJavaで実装されているためJDKを導入します。<br/>
   最新バージョンの Jenkins では Java7 以上が必要です。<br/>

   `yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel`

2.yumリポジトリへJenkinsの情報を追加<br/>

wgetコマンドを使用するため、導入がまだな方は`#yum install wget`でインストール<br/>

```
# wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
# rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
```

3.Jenkinsをインストール

`# yum install jenkins`

4.使用ポート変更

Jenkinsはデフォルトで8080ポートを使用します。<br/>
ポートを変更する場合は次の設定を行います。

```
# vi /etc/sysconfig/jenkins

-----省略-----
JENKINS_PORT="設定したいポート番号"
-----省略-----
```

5.使用するポートをファイアーウォールに登録

CentOSではデフォルトでファイアウォールが設定されています。<br/>
ポートを開放し、外部と接続します。<br/>

 ```
 # firewall-cmd --zone=public --add-port [設定したいポート番号]/tcp --permanent

 # firewall-cmd --reload
 ```

6.Jenkinsを起動

```
#起動
service jenkins start

#停止
service jenkins stop

#システム起動時に自動起動させる設定
chkconfig jenkins on
```

7.WebブラウザでJenkinsの起動確認

`http://<仮想マシンのFQDNまたはIPアドレス>:<設定したポート番号>`


【 図１ Jenkins初期画面 】
  ![Jenkins](./image/jenkins.jpg)
　<br/>

初回起動時は管理者が起動していることを確認するため、管理者パスワード「Administrator password」の入力を求められます。（ 図１赤枠部分 ）<br/>
管理者パスワード「Administrator password」は、Jenkinsをインストールした仮想マシンで確認できます。<br/>

`cat /var/lib/jenkins/secrets/initialAdminPassword`


管理者パスワードを入力すると、通常は「図4 Customize Jenkins」画面が表示されます。<br/>

しかしProxyサーバが設置されている環境では「図2 Offline」画面が表示されます。<br/>

【 図2 Offline画面 】
  ![Jenkins02](./image/jenkins_offline.jpg)
　<br/>
「Configure Proxy」をクリックし、図3の画面でProxyサーバのIPアドレス・ポートなどを順に入力し、「Save and Continue」を押下します。<br/>
【 図3 Jenkins Proxy画面 】
  ![Jenkins03](./image/jenkins_proxy.jpg)
　<br/>

次に「図4 Customize Jenkins」画面が表示されます。<br/>
ここでは Jenkinsを拡張・カスタマイズするプラグインのインストールが選択できます。<br/>
2つ選択肢が提示されますのでお選びください。
- 「Install suggested plugins」（推奨プラグインの一括インストール）
- 「Select plugins to install」（プラグインを選択してインストール）

特に何もなければ、「Install suggested plugins」（推奨プラグインの一括インストール）を選択します。<br/>
【 図4 Customize Jenkins画面 】
  ![Jenkins04](./image/jenkins_plugin.jpg)
　<br/>

「Install suggested plugins」を押下しましたら以下のように自動的にプラグインがインストールされて行きます。<br/>
【 図5 Plugin Install画面 】
  ![Jenkins05](./image/jenkins_pluginInstall.jpg)
　<br/>


プラグインのインストールが完了すると、「図5 管理者ユーザーアカウント設定画面」が表示されます。<br/>
【 図6 管理者ユーザーアカウント設定画面 】
  ![Jenkins06](./image/jenkins_user.jpg)
　<br/>
必要な項目を入力して［ Save and Finish ］ボタンを押します。<br/>
[ Continue as admin ]を選択した場合は、
管理者アカウントのユーザー名は"admin"、
パスワードは初回起動時に入力したものとなります。<br/>

初期設定が問題なく準備できましたら「図6 準備完了画面」が表示されます。<br/>
【 図7 準備完了画面 】
  ![Jenkins07](./image/jenkins_ready.jpg)
　<br/>
[ Start Using Jenkins ] ボタンを押下すれば、「Jenkinsオープニング画面」に入り、Jenkinsが利用できます。<br/>
【 図8 Jenkinsオープニング画面 】
  ![Jenkins08](./image/jenkins_opening.jpg)
　<br/>

#### 仮想サーバのJenkinsユーザについて<br/>

インストールすると自動的に jenkins グループと jenkins ユーザが作成されます。

**Jenkinsの構成**<br/>

ディレクトリ                         | パス
:----------------------------------- | :------------------------------------------
JENKINS_HOME                         | /var/lib/jenkins
設定ファイル                         | /etc/sysconfig/jenkins
キャッシュフォルダ                   | /var/cache/jenkins
ログフォルダ                         | /var/log/jenkins

いずれのフォルダも 【 ユーザ： jenkins 】、 【 グループ： jenkins 】 となっています。<br/>

**Jenkinsユーザの権限設定の方法**<br/>

CI環境を構築し、導入した各種ツールをJenkinsから操作する場合、仮想OSのJenkinsユーザに権限を与えたり、パスを通す必要があります。<br/>
ただ、むやみに権限を与えるとセキュリティ面で重大な影響を及ぼしますのでご注意ください。<br/>
以下、参考として例を示しますが、推奨しているわけではありません。<br/>
権限やパスの設定に際しては必ず開発グループなどのセキュリティ規定を考慮してご判断してください。<br/>

-------------------------------------------------------------------------------------------------------------------------------------

【 例 】 ログインシェルの変更、suコマンドの設定 <br>
Jenkins ユーザのログインシェルはデフォルトでは/bin/false に設定されています。<br/>
ここを変更することによってsuコマンドでJenkinsユーザへの切り替えが可能になります。<br/>
suコマンドでは「su rootを実行できるユーザ間でrootのパスワードを共有することになる」
「su実行後のコマンドの実行履歴がログに残らない」などセキュリティ面に懸念がありますのでご注意ください。<br/>

```
# ユーザの確認
cat /etc/passwd | grep jenkins
jenkins:x:996:994:Jenkins Automation Server:/var/lib/jenkins:/bin/false

# ログインシェル /bin/false　→　/bin/bash へ変更
chsh -s /bin/bash jenkins
jenkins のシェルを変更します。
シェルを変更しました。

# もう一度確認すると /bin/bashに変更されているのがわかります。
cat /etc/passwd | grep jenkins
jenkins:x:996:994:Jenkins Automation Server:/var/lib/jenkins:/bin/bash

# 以上でsuコマンドでjenkinsユーザへ切り替わります。
su - jenkins
[Jenkinsユーザ名]$
```

【 例 】 sudoコマンド設定<br/>
sudoコマンドでは、あるユーザが別のユーザとしてコマンドを実行できるようになります。<br/>
suコマンドではできなかった特定のコマンド単位で権限を制限することも可能です。<br/>
セキュリティ面ではsuよりもsudoの方が強化されていますが、設定に際しては充分ご注意ください。<br/>

```
# rootより設定を行います。

# Jenkinsユーザをwheelグループに追加します。
usermod -aG wheel jenkins

# visudoによりwheelグループの権限確認。コメントアウトされていれば「#」を外します。
visudo
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

# sudoの実行をパスワードなしで許可する場合は同様に「#」を外します。
## Same thing without a password
%wheel        ALL=(ALL)       NOPASSWD: ALL

# Jenkinsユーザでログインしsudoが可能か確認。
[jenkinsユーザ]$sudo whoami
root

```
以上でsudoコマンドが利用可能になり、Jenkinsユーザからroot権限が必要なコマンドが実行できるようになります。<br/>

　<br/>

### 2-2. Jenkinsの操作画面について

**ジョブ作成手順**<a name="job"></a><br/>

Jenkins上で実行される処理を「ジョブ」と呼びます。Jenkinsを利用してCI環境を構築するには各種テストやデプロイなどの各「ジョブ」を作成していきます。<br/>
ここでは基本的な操作のみを紹介します。具体的なジョブの制作例は第7章で紹介します。<br/>

「test-job」という名称のジョブを作成します。<br/>

1. トップページ [ 新規ジョブ作成 ] 押下
  ![Jenkins09](./image/newJob_jenkins.jpg)
　<br/>
2. 「Enter an item name」欄にジョブ名「test-job」を入力し、「フリースタイルプロジェクトのビルド」を選択。
![Jenkins10](./image/freeStyle_jenkins.jpg)
　<br/>
3. 「設定画面」に遷移したら「ビルド」の「ビルド手順の追加」から「シェルの実行」を選択。
![Jenkins11](./image/build_jenkins.jpg)
　<br/>

4. 行いたい処理のシェルスクリプトを記述します。<br/>
ここではコンソール画面に「Hello! Mr. Jenkins!」と表示する処理を記述します。<br/>
「保存」ボタンを押下すればジョブの完成です。
![Jenkins12](./image/sh_jenkins.jpg)
　<br/>

5. 完成したジョブ「test-job」を実行します。<br/>
「ビルド実行」を押下すると「ビルド履歴」が表示されます。<br/>
ビルドが成功していれば青い丸とともに履歴が表示されます。
![Jenkins13](./image/exe_jenkins.jpg)
　<br/>
6. 確認のためコンソール画面を見てみます。<br/>
先程の「ビルド履歴」から確認したいビルドの「# 番号」を選び、押下します。<br/>
左側のメニューの「コンソール出力」を押下すれば表示されます。
![Jenkins14](./image/console_jenkins.jpg)
　<br/>
以上がジョブ作成の基本です。<br/>

**Pipeline作成手順**<a name="pipeline"></a><br/>

「Pipeline」とは、簡単にいえばジョブをつなげて自動で実行できる機能で、
Jenkins 2.0以降では標準装備されています。<br/>
Pipelineではビルドやテストなど実行したい処理（ステップ）を「ステージ」ごとに定義することが可能で、
各ステージの管理が容易に行え、さらに開発・テストの進捗にあわせてステージの増減や順番の変更も容易に行えます。<br/>
Jenkinsを利用してビルド→テスト→デプロイなどの流れを自動化する場合には「Pipeline」機能を利用してみましょう。<br/>
ここでは基本的な設定のみを紹介します。具体的な「Pipeline」の制作例は第7章で紹介します。<br/>

動作環境<br/>

  - jenkins2.0 以上
  - java SE 7 以上
  - Pipeline Plugin ( jenkins2.0では標準装備 )

手順<br/>
[ 新規ジョブの作成 ] → [ パイプライン ]を選択<br/>
![Jenkins15](./image/pipeline01_jenkins.jpg)
　<br/>
ジョブの詳細設定画面でPipelineエリアにスクリプト記述します。
【Pipeline設定画面】
![Jenkins16](./image/pipeline02_jenkins.jpg)
　<br/>

スクリプト記述の基本形<br>
   Pipelineでは、ステージごとに処理（ステップ）を分け、それらを段階的に実行することが可能です。<br/>
   その基本的なスクリプトの記述例が以下になります。<br/>

  ```
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
また、Pipeline設定画面の下部にある「Pipeline Syntax」を押下するとサンプルコードやリファレンスを参照することができます。
Jenkinsの公式サイトにも[ Pipeline Steps Reference ](https://jenkins.io/doc/pipeline/steps/)が掲載されていますのでご参考ください。
![Jenkins17](./image/pipelineSyntax.jpg)
　<br/>

基本的なPipelineを作成して実行してみます。<br/>
Pipeline名は「test-pipeline」。<br/>
実行する処理は Stage01「 Hello! Mr.Jenkins.」、Stage02「 Bye! Mr.Jenkins.」とコンソール出力をします。<br/>

```
node {
    stage('stage01'){
        sh 'echo "Hello! Mr.Jenkins."'
    }
    stage('stage02'){
        sh 'echo "Bye! Mr.Jenkins"'
    }
}
```
上記のスクリプトを 【Pipeline設定画面】の「パイプライン」-「Script」欄に記述し、設定を保存したら、ビルドを実行します。<br/>
Pipelineが上手く実行されれば下図のような実行結果が表示されます。</br>

【Pipeline実行結果画面】
![Jenkins18](./image/exe_pipeline.jpg)
　<br/>

**プラグイン機能**<br/>
Jenkins ではプラグインにより機能を拡張することが出来るのが大きな特徴です。<br/>
豊富なプラグインが用意されており、Jenkins の管理画面からプラグインを検索し、インストールすることで簡単にプラグインを導入できます。<br/>

プラグイン導入手順<br/>

`トップ画面の「Jenkinsの管理」→「プラグインの管理」→「利用可能」から 利用したいプラグインを選択 `<br/>
※Jenkins のプラグインには、そのプラグインを利用するために別のプラグインが必要な場合があります。<br/>
 プラグインの依存関係に注意してください。 <br/>
![Jenkins19](./image/plugin_jenkins.jpg)
　<br/>

本ガイドで必要となるプラグイン<br>

- [Git Plugin](https://wiki.jenkins.io/display/JENKINS/Git+Plugin)<br/>
インストール後、「GitHub Enterprise」と連携したJenkinsのジョブが作成可能になります。<br/>

- [SSH Agent Plugin](https://jenkins.io/doc/pipeline/steps/ssh-agent/)<br/>
SSH鍵認証を行えるようになります。<br/>

なお、「プラグインの管理」画面で「インストール済み」タブを選択すれば、既に導入済みの プラグイン が確認できます。<br/>
初期画面ではAから始まる名称のプラグインの一覧が表示されます。<br>
画面右上の[ フィルター ]欄に検索したいプラグイン名を記入し検索することも可能です。
![Jenkins20](./image/plugin_check.jpg)
　<br/>

**メール機能**<br/>
Jenkinsではビルドの実行結果をメールで通知することができます。複数人で開発・テストを行う際には必要な設定です。<br/>
基本的な「E-mail 通知」機能では、ビルド失敗時にのみメールが送信される設定ですが、
メール機能を拡張するプラグイン「Email Extension Plugin」を導入すれば、「拡張E-mail通知」の設定が可能になり、
ビルド失敗時だけでなく成功時にも送ることが可能で、ビルドの実行状況に応じて送信内容を替えることも可能になるなどカスタマイズができます。<br/>

**基本的なメール設定**<br/>

SMTPメールサーバーの設定<br>

`トップ画面「Jenkinsの管理」→「システムの設定」→「E-mail 通知」`<br/>
SMTPサーバーが用意できない場合は Gmail のSMTPサーバが利用できます。<br/>
以下は Gmail のSMTPサーバを利用した設定です。

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

【設定例 画像】<br/>
![メール設定](./image/mail.jpg)
　<br/>



各ジョブでの設定<br/>

メール通知を設定したいジョブの[ 設定画面 ] → [ ビルド後の処理 ]にある[ ビルド後の処理の追加 ]を押下し、プルダウンメニューから[ E-mail通知 ]を選択します。<br/>
以下の画面が表示されますので宛先にアドレスを記入すればメールはビルド失敗時に送られるようになります。<br/>
![Jenkins20](./image/email_job.jpg)
　<br/>

**拡張E-mail通知の設定**<a name="extend_email"></a><br/>

設定場所は `トップ画面「Jenkinsの管理」→「システムの設定」→「拡張E-mail 通知」`<br/>
「拡張E-mail通知」では様々な設定が可能なため、設定項目も数多く用意されています。<br/>
ここでは、最低限の項目の紹介にとどめます。<br/>

設定項目                        | 設定する内容
:------------------------------ | :------------------------------
SMTPサーバー                    | 送信に利用するSMTPサーバを設定
デフォルトE-mailのサフィックス  | @以降のデフォルト値を設定
デフォルトコンテンツ形式        | プレーンテキスト形式かhtmlメール形式か選択
Default Recipients              | 送信先メールアドレス
デフォルトサブジェクト          | デフォルトのメールタイトルを設定
デフォルトコンテンツ            | デフォルトのメールの本文を設定
　<br/>

以下は Gmail のSMTPサーバを利用した設定です。<br/>
【拡張E-mail通知 設定例 画像】<br/>

![拡張E-mail](./image/mail01.jpg)
![拡張E-mail](./image/mail02.jpg)
![拡張E-mail](./image/mail03.jpg)
　<br/>

上記設定例では `${PROJECT_NAME}` などのトークンを利用して記述しています。<br/>

設定項目の最後にある「トークンリファレンス」のヒントを押下すると利用可能なトークンの一覧が表示されます。<br/>

適宜参考にして設定にご利用ください。<br/>

【トークンリファレンス 画像】<br/>

![mail_token](./image/mail_token.jpg)
　<br/>

各ジョブでの設定<br/>

メール通知を設定したいジョブの [ 設定画面 ] → [ ビルド後の処理 ]にある[ ビルド後の処理の追加 ]を押下し、プルダウンメニューから[ E-mail通知 ]を選択します。<br/>
ジョブでの設定内容はシステムの設定で行ったものとほぼ同じです。また、システムで設定した項目を引き継ぐことも、あるいは個別に変更することも可能です。<br/>
参考例は第7章でご紹介します。<br/>

　<br/>

### 2-3. Hexo導入手順<a name="hexo"></a><br/>

 本ガイドでは、静的ページジェネレータ [「 Hexo 」](https://hexo.io/)を利用した開発を行います。

1.　Hexo環境の導入手順

Hexo を導入する仮想サーバで作業を行います。

Hexo は Node で作成されているため Node.js の導入が必要となります。

以下では、Node.js は導入済みとして Hexo の導入を行います。

 ```
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

  （firewallの設定で4000番ポートの開放を行ってください。）


 以上で「 Hexo 」作業フォルダが準備できました。



2.　 Hexo 記事の作成と HTML の生成

 Hexo は Markdown 形式のファイルから HTMLファイル を生成します。

 Markdown 形式のファイルの作成も Hexo で行うことができ、新しい記事を追加していくことができます。

 ここでは「 Hello Hexo 」というタイトルで記事を作成していきます。

 Hexo を導入したディレクトリで次のコマンドを実行します。

 ` hexo new post  "Hello Hexo" `

 Hexo を導入したディレクトリ配下に` /source/_posts/Hello-Hexo.md ` が作成されます。

生成された Markdown ファイルの中は以下のようになっています。

```
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

記事の作成が完了したら Markdown 形式ファイルから HTML ファイルへ生成します。

` hexo generate ` コマンドで htmlファイルが生成され、publicフォルダ以下に格納されます。

以上で「 Hexo 」に新たな記事が追加されました。<br/>

 【参考： Hexo画面 】

  ![Hexo](./image/hexo.jpg)
　<br/>

3.　 その他のHexoの使い方

テーマ（theme）の変更

>Hexoではテーマの変更も簡単に行えます。<br/>
>
>以下手順です。
>
>①公式サイトの[ theme ](https://hexo.io/themes/)より好きなテーマを選びます。<br/>
>②選択したテーマのタイトルのGithubページからクローンを行います。<br/>
>　Hexoを導入したディレクトリ配下の themes ディレクトリがクローン先です。<br/>
>　例：テーマ「Clean-blog」をthemesディレクトリへクローン<br/>
>　`git clone https://github.com/klugjo/hexo-theme-clean-blog.git themes/clean-blog`<br/>
>③Hexoを導入したディレクトリ配下にある「_config.yml」を修正します。<br/>
>　デフォルトでは`theme: landscape`となっている部分を`theme: テーマ名`に変更します。<br/>
>　例：`theme: clean-blog`<br/>
>
>　以上でテーマが変更できます。<br/>
【参考： Hexo画面 】

  ![Hexoテーマの変更](./image/hexo_theme.jpg)

[[第3章 GitHub Enterprise環境構築へ]](github-enterprise.md)
