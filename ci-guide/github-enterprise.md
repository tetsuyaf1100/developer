## 第3章　GitHubEnterprise環境構築

### 3-1.GitHubEnterprise 導入手順

FUJITSU Cloud Service K5では、分散型のバージョン管理システム Git の
ウェブサービス[「 GitHub Enterprise 」](http://jp.fujitsu.com/solutions/cloud/k5/function/paas/github/)がご利用いただけます。<br/>
「 GitHubEnterprise 」と Jenkins などの CI ツールと組み合わせることで自動デプロイが可能なCI環境が構築できます。<br/>
特に複数人が参加するチーム開発において「 GitHub Enterprise 」の利用は開発資産管理のフローを簡略化し効果的な運用を実現できます。<br/>
本ガイドでは、効率的な資産管理を実現するワークフロー「Github Flow」を意識してCI環境を構築していきます。<br/>

「 GitHub Enterprise 」全般に関する情報は [「 GitHub Enterprise 」ご紹介資料](http://jp.fujitsu.com/solutions/cloud/k5/document/pdf/k5-github-function-overview.pdf)　をご参考ください。

以下では、「 GitHub Enterprise 」のアカウント取得済みの前提で説明します。

-------------------------------------------------------------------------------------------------------------------

#### リポジトリ作成方法<a name="repository"></a><br/>

1.リモートリポジトリの作成

 「 GitHubEnterprise 」の画面で新規のリポジトリを作成します。<br/>
 トップ画面中央の[Start a project]を押下、または右下の [New repository]を押下します。<br/>
 ![GHE01](./image/repository_ghe.jpg)
　<br/>
次画面に遷移したら「Repository name」を入力し、[ Create repository ]を押下でリモートリポジトリが作成されます。<br/>
 ![GHE02](./image/repository_creat.jpg)
　<br/>
サンプルとして「Repository name」を「test-github」として作成しました。<br/>
作成されたリモートリポジトリの初期画面です。<br/>
![GHE03](./image/remote_repository.jpg)
　<br/>


2.ローカルリポジトリの作成

 仮想サーバ上にローカルリポジトリを作成し、Gitリポジトリにします。<br/>
 先程作成したリモートリポジトリ「test-github」を利用して作成していきます。

```
# gitコマンドが使えるようにGitをインストールします。
yum -y install git

# 作業用のディレクトリを用意し、中に入ります。
mkdir <ローカルリポジトリ名>
cd <ローカルリポジトリ>

# 動作確認用に「 README.md 」を作成します。
echo "# test-github" >> README.md

# Gitリポジトリ化します。
git init

#「 GitHubEnterprise 」の画面で作成したリモートリポジトリ情報を登録します。
git remote add origin https://github.com/ユーザ名/test-github(リモートリポジトリ名)

（# sshで接続する場合は）
（git remote add origin git@github.com:ユーザ名/test-github(リモートリポジトリ名）

# 「README.md 」のファイルをインデックスに追加
git add README.md

# コミット
git commit -m "[コミットのコメント記入]"

# プッシュして ローカルリポジトリをリモートリポジトリへ反映させます。
git push -u origin master

#「 GitHubEnterprise 」に登録したユーザー名を聞かれます。
Username for 'https://github.com': ここにユーザ名を入力

# 続けて同じく登録したパスワードを入力します。
Password for 'https://ユーザ名@github.com': ここにパスワード入力


```

「 GitHubEnterprise 」画面で確認

`https://github.com/ユーザ名/test-github(リポジトリ名)`

![GHE04](./image/repository_push.jpg)
　<br/>
動作確認用に作成した「 README.md 」が格納され、画面に「 test-github 」が表示されていれば完了です。<br/>
以上で開発資産管理の場として「 GitHubEnterprise 」の準備ができました。<br/>

　<br>

### 3-2.PullRequestとMerge<a name="git_function"></a><br/>

「 GitHubEnterprise 」による資産管理を行う上で欠かせない機能が「PullRequest」と「Merge」です。<br/>

ここではチーム開発における効率的な資産管理を実現するGithubの運用モデル「 GitHub Flow 」を意識して、
「PullRequest」と「Merge」の基本操作を説明します。<br/>

「GitHub Flow」に関して詳しくはGitHub公式ガイドの[「 Understanding the GitHub Flow 」](https://guides.github.com/introduction/flow/)ページを参照ください。<br/>

「Github Flow」では、1つのリポジトリに「 master 」ブランチと「開発用ブランチ」の2つのブランチを切り、
各開発者がローカルで作業したものを「開発用ブランチ」へpushし、「Pullrequest」機能でレビュー依頼をします。
レビュー完了後、資産管理責任者が「master」ブランチへ「merge」を行ってデプロイするという流れになります。<br/>
「Github Flow」に従ってリポジトリの運用を行うことで開発チーム内で効率的なソースレビューを行えるよう目指します。<br/>

-----------------------------------------------------------------------------------------------------

#### ■ Pullrequest<br>

Pullrequestは分散型のバージョン管理システム GitHub の最も特徴的な機能です。<br/>
複数人が参加するチーム開発において資産管理をGithubで行った場合、各開発担当者は各自のローカルリポジトリで作業を行うことになりますが、
各開発者がローカルリポジトリで加えた変更を他の開発者に通知する機能がPullrequestです。<br/>

**PullRequest 手順**<a name="pullreq"></a><br/>

リポジトリにプルリクエスト用のブランチを作成します。<br/>
ここでは「sample-branch」という名前でブランチを作成します。<br/>

```
# プルリクエストを行うリポジトリへ入ります。
cd <リポジトリのディレクトリ名>

# ブランチ作成
git checkout -b <ブランチ名(sample-branch)>

# git branchコマンドで、存在するブランチの一覧を確認
git branch
  master
* sample-branch

# 作成したブランチに入り作業します。
git checkout <ブランチ名(sample-branch)>
```

もし、プルリクエストを行うリポジトリが仮想サーバにまだ用意していなかった場合は「 GitHubEnterprise 」画面からクローンします。<br/>
「 GitHubEnterprise 」画面からクローンするためのコードを取得します。<br/>
[ Clone or download ]を押下し表示された https をコピーします。<br/>
以下は先程作成したリモートリポジトリ「test-github」を使用した例です。<br/>

![GHE05](./image/clone.jpg)
　<br/>
次に仮想サーバへ入り、以下のコマンドを入力します。<br/>
` git clone https://github.com/ユーザ名/test-github.git`<br/>

クローンが成功するとクローンしたリポジトリ名のディレクトリが作成されます。<br/>
そのディレクトリへ入り、先程の手順でブランチを作成します。<br/>


ブランチが用意できましたら「Pullrequest」動作確認用に作業します。<br/>

確認用のREADME.mdを作成します。<br/>
`echo "# sample-branch for Pullrequest" >> README.md`<br/>

作成したMDファイルをコミットし、sample-branchブランチへプッシュします。<br/>
```
# 作成したMDファイルをインデックスに追加。
git add README.md

# コミットし「プルリクエスト動作確認」とメッセージをつけます。
git commit -m "プルリクエスト動作確認"

# sample-branchブランチへプッシュします。
git push -u origin sample-branch
```


画面で確認します。「sample-branch」へpushされたことが分かります。<br/>

![GHE06](./image/pullreq_branch.jpg)
　<br/>
上の画面の赤枠 [ Compare & pull request ] を押下してプルリクエストを作成します。<br/>

次画面に遷移しましたら、中央のテキストボックスにメッセージを記入し、[ Create pull request ]を押下すれば、プルリクエストの完了です。<br/>

![GHE07](./image/pullreq_message.jpg)
　<br/>

遷移した画面で作成したプルリクエストの状態を確認することができます。<br/>

![GHE08](./image/pullreq_create.jpg)
　<br/>


#### ■ Merge <a name="merge"></a><br/>

「Pull request」でレビュー依頼を受けた開発責任者は、レビューを実施後、問題なければ「master」ブランチとプルリクエストのブランチ「sample-branch」を「merge」し、
開発資産の統合をはかります。<br/>

**Merge 手順**<br/>

まずは、各ブランチの差異を確認します。<br/>
「Pull requests」のページの [ Files changed ] タブを押下し、コミット内容をレビューします。<br/>
確認用に作成した「README.md」ファイルの状況が画面中央に表示されます。<br/>

![GHE09](./image/pullreq_fileChange.jpg)
　<br/>
レビューが終わりましたら [ Conversation ] タブを押下し、メッセージを記入し、[ Comment ] を押下します。

![GHE10](./image/merge_message.jpg)
　<br/>
レビュー完了しましたので、[ Merge pull request ]を押下し「 merge 」します。

![GHE11](./image/merge.jpg)
　<br/>

 GitHub では「 Pull request」の「 merge 」の方法が画面から選択できるようになりました。<br/>
 [ Merge pull request ]ボタンをプルダウンしますと、3つの「 merge 」方法が選択できます。<br/>

 ![GHE12](./image/merge_3patterns.jpg)
　<br/>

> [ Create a merge commit ]<br/>
> All commits from this branch will be added to the base branch via a merge commit.<br/>
> デフォルトの「 merge 」方法です。<br/>
> プルリクエストしたブランチに存在するすべてのコミットはマージコミットを経てベースブランチ（本ガイドではmasterブランチ）へ統合されます。<br/>
>
> [ Squash and merge ]<br/>
> The 1 commit from this branch will be added to the base branch.<br/>
> プルリクエスしたブランチに複数のコミットがあった場合、それらを１つにまとめて１つのコミットとしてmasterブランチへ統合します。<br/>
> プルリクエストの複数のコミットの履歴はmasterには反映されず、１つのコミットとして扱われます。<br/>
> 細かな修正や追加で大量のコミットが発生した場合にそれらを1回のコミットとして扱うようなイメージです。<br/>
>
> [ Rebase and merge ]<br/>
> The 1 commit from this branch will be rebased and added to the base branch.<br/>
> プルリクエストしたブランチに存在するコミットをリベースして１つ１つ履歴を残してmasterブランチへ統合します。<br/>
> 分岐した作業履歴を分かりやすく一直線の作業履歴に変えるイメージです。<br/>

詳しくは公式サイトの[ 「 About pull request merges 」](https://help.github.com/articles/about-pull-request-merges/)を参照ください。<br/>

[ Merge pull request ] を押下すると、最終確認のため [ Confirm ] ボタンが出現します。それを押すとmerge実行です。<br/>

 ![GHE13](./image/merge_success.jpg)
　<br/>
上図赤枠「 Pull request successfully merged and closed 」とプルリクエストのマージが成功したことのメッセージが出現すれば完了です。<br/>
また、同じく赤枠の[Delete branch]を押下すると「 Pull request」で使用したブランチを削除することができます。<br/>

以上を踏まえて、開発チーム内で「 Pull request 」 と「 merge 」を 効果的に行ってください。
