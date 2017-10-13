# PostgreSQL Cluster マルチインスタンス テンプレート概要説明

## 概要

PostgreSQLを３つのインスタンスにインストールし、クラスタ化します。

## 作成されるシステムの構成図

![構成図](images/diag_postgresql_cluster_mult.png)

## インスタンスの詳細

### インスタンス１

|項目|内容|
|---|---|
|OS|CentOS 6.5 64bit|
|イメージタイプ|CentOS 6.5 64bit (English) 05|
|フレーバータイプ|S-1|
|ボリュームタイプ|M1|

#### インストールするソフトウェア

|ソフトウェア|バージョン|ライセンス|説明|
|---|---|---|---|
|Postgres|9.5|[PostgreSQL License](https://opensource.org/licenses/postgresql)|PostgreSQLパッケージ|

### インスタンス２

|項目|内容|
|---|---|
|OS|CentOS 6.5 64bit|
|イメージタイプ|CentOS 6.5 64bit (English) 05|
|フレーバータイプ|S-1|
|ボリュームタイプ|M1|

#### インストールするソフトウェア

|ソフトウェア|バージョン|ライセンス|説明|
|---|---|---|---|
|Postgres|9.5|[PostgreSQL License](https://opensource.org/licenses/postgresql)|PostgreSQLパッケージ|

### インスタンス３

|項目|内容|
|---|---|
|OS|CentOS 6.5 64bit|
|イメージタイプ|CentOS 6.5 64bit (English) 05|
|フレーバータイプ|S-1|
|ボリュームタイプ|M1|

#### インストールするソフトウェア

|ソフトウェア|バージョン|ライセンス|説明|
|---|---|---|---|
|Postgres|9.5|[PostgreSQL License](https://opensource.org/licenses/postgresql)|PostgreSQLパッケージ|

## 作成方法

[IaaSテンプレート利用ガイド](../usage.md)を参照して下さい。

## 作成時パラメタ

|パラメタ名|入力する値の型|説明|
|---|---|---|
|keypair_name|string|使用する証明書の鍵を指定|
|availability_zone|string|アベイラビリティーゾーンを指定|
|dns_nameservers|comma_delimited_list|DNSネームサーバを指定<br>`['xxx.xxx.xxx.xxx', 'yyy.yyy.yyy.yyy']`形式|
|network_id_postgre_cluster1|string|インスタンス１が所属するネットワークIDを指定|
|subnet_id_postgre_cluster1|string |インスタンス１が所属するサブネットIDを指定|
|network_id_postgre_cluster2|string|インスタンス２が所属するネットワークIDを指定|
|subnet_id_postgre_cluster2|string |インスタンス２が所属するサブネットIDを指定|
|network_id_postgre_cluster3|string|インスタンス３が所属するネットワークIDを指定|
|subnet_id_postgre_cluster3|string |インスタンス３が所属するサブネットIDを指定|
|cluster1_host_cider|string|インスタンス１へのSSH接続を許可するCIDRを指定|
|cluster2_host_cider|string|インスタンス２へのSSH接続を許可するCIDRを指定|
|cluster3_host_cider|string|インスタンス３へのSSH接続を許可するCIDRを指定|
|remote_host_cidr|string|サーバへのSSH接続を許可するCIDRを指定|
|flavor|string|作成するインスタンスのフレーバーを指定|

## セキュリティグループ

### 共通

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|ICMP|●|－|remote_host_cidr|ICMP |
|ICMP|－|●|0.0.0.0/0|ICMP |
|SSH(TCP)|●|－|remote_host_cidr|22|
|HTTP(TCP)|－|●|0.0.0.0/0|80|
|HTTPS(TCP)|－|●|0.0.0.0/0|443|
|TCP|－|●|dns_nameservers,0|53|
|TCP|－|●|dns_nameservers,1|53|
|UDP|－|●|dns_nameservers,0|53|
|UDP|－|●|dns_nameservers,1|53|
|TCP|－|●|169.254.169.254/32|80|

### インスタンス１

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|TCP|●|－|cluster2_host_cider|5432|
|TCP|－|●|cluster2_host_cider|5432|
|TCP|●|－|cluster3_host_cider|5432|
|TCP|－|●|cluster3_host_cider|5432|

### インスタンス２

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|TCP|●|－|cluster1_host_cider|5432|
|TCP|－|●|cluster1_host_cider|5432|
|TCP|●|－|cluster3_host_cider|5432|
|TCP|－|●|cluster3_host_cider|5432|

### インスタンス３

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|TCP|●|－|cluster1_host_cider|5432|
|TCP|－|●|cluster1_host_cider|5432|
|TCP|●|－|cluster2_host_cider|5432|
|TCP|－|●|cluster2_host_cider|5432|

## 出力情報

３インスタンスのIPアドレスを`http://xxx.xxx.xxx.xxx`形式で出力

## 起動方法

出力情報のインスタンス１IPアドレスにブラウザからアクセス

## その他
