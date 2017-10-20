# FUJITSU Cloud Service K5 CI 環境構築ガイド

## まえがき

### 本ガイドの目的

本ガイドはCI(継続的インテグレーション)を実現するために FUJITSU Cloud Service K5 (以下 K5) を利用したCI環境構築の手順を説明しています。

### 対象読者

本ガイドの対象者は、K5上でCI環境構築を行いたい方になります。

本書を読むためには、以下の知識が必要です。

- インターネットに関する基本的な知識
- 使用するオペレーティングシステムに関する基本的な知識
- CI(継続的インテグレーション)に関する基本的な知識
- GitHubに関する基本的な知識
- Cloud Foundryに関する基本的な知識

### 前提

本ガイドの利用にあたっては以下を前提としています。

- K5のAPIが操作できること
- 作業を行うアカウントが以下の設計・構築者ロール(cpf\_systemowner)を有していること

### 注意事項

本ガイドで使用しているサンプルファイルは自己責任での利用をお願い致します。
また、使用しているツールの利用については、各ツールの利用規約に同意した上でご使用下さい。
本ガイドで示す環境構築および運用に関しましては、所属する組織等のセキュリティポリシーに必ず従ってください。

### 参考資料

本ガイドを利用するにあたって、参考となる資料を以下に示します。

- [FUJITSU Cloud Service K5 IaaS ドキュメント・ツール類](https://k5-doc.jp-east-1.paas.cloud.global.fujitsu.com/doc/jp/iaas/document/list/doclist_iaas.html)

## 目次

[概要](overview.md)

1. CI(継続的インテグレーション)について
1. CI環境の構成

   1. 基本システム構成
   1. 想定利用シナリオ
   1. 想定利用シナリオを基にしたシステム構成
   1. システム構成図とシナリオ運用概要図

[第1章 K5 IaaS環境構築](iaas.md)

1. K5 IaaS環境構築について
1. 仮想OS CentOS7 導入について

[第2章 CIサーバ環境構築](ci-server.md)

1. Jenkins導入手順

   1. Jenkinsのインストール
   1. 仮想サーバのJenkinsユーザについて

1. Jenkinsの操作画面について

   1. ジョブ作成手順
   1. pipeline作成手順
   1. プラグイン機能
   1. メール通知機能

1. Hexo導入手順

   1. Hexo環境の導入手順
   1. Hexo 記事の作成と HTML の生成
   1. その他のHexoの使い方

[第3章 GitHub Enterprise環境構築](github-enterprise.md)

1. GitHub Enterprise導入手順

   1. リポジトリ作成方法
   1. リモートリポジトリの作成方法
   1. ローカルリポジトリの作成方法

1. Pull requestとmerge

   1. Pull request
   1. merge

[第4章 JenkinsとGitHubの連携](configuration.md)

1. GitHub EnterpriseのJenkinsへのトリガー
1. Webhook設定方法

   1. Jenkins側の設定方法
   1. GitHub側の設定方法

1. SSH認証の設定方法

   1. Jenkins側の設定方法
   1. GitHub側の設定方法

[第5章 CFの説明](cf.md)

1. CF導入方法（ビルドパック）および環境設定方法
1. CFアップロード手順

[第6章 テストツールの導入](test-tools.md)

1. 各種テストツール導入と実行コマンド

   1. mdファイル構文チェック「markdownlint」
   1. html構文チェックツール「HTMLHint」
   1. 脆弱性検査ツール「Skipfish」

[第7章 CI用Pipelineの設定](pipeline.md)

1. Jenkinsのジョブの作成
1. Jenkins パイプラインの作成方法

   1. Pull request用のpipeline設定
   1. Merge用のpipeline設定

[第8章 デモ実行と運用](demo.md)

1. 「想定利用シナリオ」の実行と運用
