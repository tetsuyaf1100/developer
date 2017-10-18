# 第3章　GitHub Enterprise環境構築

## 3-1. GitHub Enterprise 導入手順

FUJITSU Cloud Service K5では、分散型のバージョン管理システム Git の
ウェブサービス[「 GitHub Enterprise 」](http://jp.fujitsu.com/solutions/cloud/k5/function/paas/github/)がご利用いただけます。

「 GitHub Enterprise 」と Jenkins などの CI ツールと組み合わせることで自動デプロイが可能なCI環境が構築できます。

特に複数人が参加するチーム開発において「 GitHub Enterprise 」の利用は開発資産管理のフローを簡略化し効果的な運用を実現できます。

本ガイドでは、効率的な資産管理を実現するワークフロー「Github Flow」を意識してCI環境を構築していきます。

「 GitHub Enterprise 」全般に関する情報は [「 GitHub Enterprise 」ご紹介資料](http://jp.fujitsu.com/solutions/cloud/k5/document/pdf/k5-github-function-overview.pdf)　をご参考ください。

以下では、「 GitHub Enterprise 」のアカウント取得済みの前提で説明します。

-------------------------------------------------------------------------------------------------------------------

## リポジトリ作成方法

1.リモートリポジトリの作成

 「 GitHub Enterprise 」の画面で新規のリポジトリを作成します。
 
 トップ画面中央の[Start a project]を押下、または右下の [New repository]を押下します。
 
 ![GHE01](./image/repository_ghe.jpg)
 
次画面に遷移したら「Repository name」を入力し、[ Create repository ]を押下でリモートリポジトリが作成されます。

 ![GHE02](./image/repository_creat.jpg)

サンプルとして「Repository name」を「test-github」として作成しました。

作成されたリモートリポジトリの初期画面です。

![GHE03](./image/remote_repository.jpg)



2.ローカルリポジトリの作成

 仮想サーバ上にローカルリポジトリを作成し、Gitリポジトリにします。

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

#「 GitHub Enterprise 」の画面で作成したリモートリポジトリ情報を登録します。
git remote add origin https://git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com/ユーザ名/test-github(リモートリポジトリ名).git
※注意：GitHub Enterprise のリポジトリurlのFQDN部分はご利用者ごとに異なります。

（# sshで接続する場合は）
（git remote add origin git@git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com:ユーザ名/test-github(リモートリポジトリ名).git)

# 「README.md 」のファイルをインデックスに追加
git add README.md

# コミット
git commit -m "[コミットのコメント記入]"

# プッシュして ローカルリポジトリをリモートリポジトリへ反映させます。
git push -u origin master

#「 GitHub Enterprise 」に登録したユーザー名を聞かれます。
Username for 'https://git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com/': 
ここにユーザ名を入力

# 続けて同じく登録したパスワードを入力します。
Password for 'https://ユーザ名@git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com': 
ここにパスワード入力


```

「 GitHub Enterprise 」画面で確認

`git remote add origin https://git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com/ユーザ名/test-github(リモートリポジトリ名).git`

![GHE04](./image/repository_push.jpg)

動作確認用に作成した「 README.md 」が格納され、画面に「 test-github 」が表示されていれば完了です。

以上で開発資産管理の場として「 GitHub Enterprise 」の準備ができました。



## 3-2. PullRequestとMerge

「 GitHub Enterprise 」による資産管理を行う上で欠かせない機能が「PullRequest」と「Merge」です。

ここではチーム開発における効率的な資産管理を実現するGithubの運用モデル「 GitHub Flow 」を意識して、
「PullRequest」と「Merge」の基本操作を説明します。

「GitHub Flow」に関して詳しくはGitHub公式ガイドの[「 Understanding the GitHub Flow 」](https://guides.github.com/introduction/flow/)ページを参照ください。

「Github Flow」では、1つのリポジトリに「 master 」ブランチと「開発用ブランチ」の2つのブランチを切り、
各開発者がローカルで作業したものを「開発用ブランチ」へpushし、「Pullrequest」機能でレビュー依頼をします。

レビュー完了後、資産管理責任者が「master」ブランチへ「merge」を行ってデプロイするという流れになります。

「Github Flow」に従ってリポジトリの運用を行うことで開発チーム内で効率的なソースレビューを行えるよう目指します。

-----------------------------------------------------------------------------------------------------

### ■ Pullrequest

Pullrequestは分散型のバージョン管理システム GitHub の最も特徴的な機能です。

複数人が参加するチーム開発において資産管理を Github で行った場合、各開発担当者は各自のローカルリポジトリで作業を行うことになりますが、
各開発者がローカルリポジトリで加えた変更を他の開発者に通知する機能が Pullrequestです。


**PullRequest 手順**<a name="pullreq"></a>

リポジトリにプルリクエスト用のブランチを作成します。

ここでは「sample-branch」という名前でブランチを作成します。

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

もし、プルリクエストを行うリポジトリが仮想サーバにまだ用意していなかった場合は「 GitHub Enterprise 」画面からクローンします。

「 GitHub Enterprise 」画面からクローンするためのコードを取得します。

[ Clone or download ]を押下し表示された https をコピーします。

以下は先程作成したリモートリポジトリ「test-github」を使用した例です。

![GHE05](./image/clone.jpg)


次に仮想サーバへ入り、以下のコマンドを入力します。

` git clone https://git-dXXXXrbo.jp-east-1.paas.cloud.global.fujitsu.com/ユーザ名/test-github(リモートリポジトリ名).git`


クローンが成功するとクローンしたリポジトリ名のディレクトリが作成されます。

そのディレクトリへ入り、先程の手順でブランチを作成します。


ブランチが用意できましたら「Pullrequest」動作確認用に作業します。

確認用のREADME.mdを作成します。

`echo "# sample-branch for Pullrequest" >> README.md`

作成したMDファイルをコミットし、sample-branchブランチへプッシュします。

```
# 作成したMDファイルをインデックスに追加。
git add README.md

# コミットし「プルリクエスト動作確認」とメッセージをつけます。
git commit -m "プルリクエスト動作確認"

# sample-branchブランチへプッシュします。
git push -u origin sample-branch
```


画面で確認します。「sample-branch」へpushされたことが分かります。

![GHE06](./image/pullreq_branch.jpg)

上の画面の赤枠 [ Compare & pull request ] を押下してプルリクエストを作成します。

次画面に遷移しましたら、中央のテキストボックスにメッセージを記入し、[ Create pull request ]を押下すれば、プルリクエストの完了です。

![GHE07](./image/pullreq_message.jpg)


遷移した画面で作成したプルリクエストの状態を確認することができます。

![GHE08](./image/pullreq_create.jpg)



### ■ Merge

「Pull request」でレビュー依頼を受けた開発責任者は、レビューを実施後、問題なければ「master」ブランチと
プルリクエストのブランチ「sample-branch」を「merge」し、開発資産の統合をはかります。

**Merge 手順**

まずは、各ブランチの差異を確認します。<br/>
「Pull requests」のページの [ Files changed ] タブを押下し、コミット内容をレビューします。

確認用に作成した「README.md」ファイルの状況が画面中央に表示されます。

![GHE09](./image/pullreq_fileChange.jpg)

レビューが終わりましたら [ Conversation ] タブを押下し、メッセージを記入し、[ Comment ] を押下します。

![GHE10](./image/merge_message.jpg)

レビュー完了しましたので、[ Merge pull request ]を押下し「 merge 」します。

![GHE11](./image/merge.jpg)


 GitHub では「 Pull request」の「 merge 」の方法が画面から選択できるようになりました。
 
 [ Merge pull request ]ボタンをプルダウンしますと、3つの「 merge 」方法が選択できます。

 ![GHE12](./image/merge_3patterns.jpg)


> [ Create a merge commit ]
>
> All commits from this branch will be added to the base branch via a merge commit.
>
> デフォルトの「 merge 」方法です。
>
> プルリクエストしたブランチに存在するすべてのコミットはマージコミットを経てベースブランチ（本ガイドではmasterブランチ）へ統合されます。


> [ Squash and merge ]
>
> The 1 commit from this branch will be added to the base branch.
>
> プルリクエスしたブランチに複数のコミットがあった場合、それらを１つにまとめて１つのコミットとしてmasterブランチへ統合します。
>
> プルリクエストの複数のコミットの履歴はmasterには反映されず、１つのコミットとして扱われます。
>
> 細かな修正や追加で大量のコミットが発生した場合にそれらを1回のコミットとして扱うようなイメージです。


> [ Rebase and merge ]
>
> The 1 commit from this branch will be rebased and added to the base branch.
>
> プルリクエストしたブランチに存在するコミットをリベースして１つ１つ履歴を残してmasterブランチへ統合します。
>
> 分岐した作業履歴を分かりやすく一直線の作業履歴に変えるイメージです。
>

詳しくは公式サイトの[ 「 About pull request merges 」](https://help.github.com/articles/about-pull-request-merges/)を参照ください。

[ Merge pull request ] を押下すると、最終確認のため [ Confirm ] ボタンが出現します。それを押すとmerge実行です。

 ![GHE13](./image/merge_success.jpg)

上図赤枠「 Pull request successfully merged and closed 」とプルリクエストのマージが成功したことのメッセージが出現すれば完了です。

また、同じく赤枠の[Delete branch]を押下すると「 Pull request」で使用したブランチを削除することができます。

以上を踏まえて、開発チーム内で「 Pull request 」 と「 merge 」を 効果的に行ってください。

[[第4章 JenkinsとGitHubの連携へ]](configuration.md)
