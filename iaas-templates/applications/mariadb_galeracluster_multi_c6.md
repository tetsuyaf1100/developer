# MariaDB Galera Cluster マルチインスタンス テンプレート概要説明

## 概要

MariaDBを２つのインスタンスにインストールし、クラスタ化します。

## 作成されるシステムの構成図

![構成図](images/diag_mariadb_cluster_multi.png)

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
|MariaDB|10.1|[GNU GENERAL PUBLIC LICENSE Version 2](https://mariadb.com/kb/en/mariadb/mariadb-license/)|MariaDB|

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
|MariaDB|10.1|[GNU GENERAL PUBLIC LICENSE Version 2](https://mariadb.com/kb/en/mariadb/mariadb-license/)|MariaDB|

## 作成方法

[IaaSテンプレート利用ガイド](../usage.md)を参照して下さい。

## 作成時パラメタ

|パラメタ名|入力する値の型|説明|
|---|---|---|
|keypair_name|string|使用する証明書の鍵を指定|
|availability_zone|string|アベイラビリティーゾーンを指定|
|dns_nameservers|comma_delimited_list|DNSネームサーバを指定<br>`['xxx.xxx.xxx.xxx', 'yyy.yyy.yyy.yyy']`形式|
|network_id_mariadb_galeracluster1|string|インスタンス１が所属するネットワークIDを指定|
|subnet_id_mariadb_galeracluster1|string |インスタンス１が所属するサブネットIDを指定|
|network_id_mariadb_galeracluster2|string|インスタンス２が所属するネットワークIDを指定|
|subnet_id_mariadb_galeracluster2|string |インスタンス２が所属するサブネットIDを指定|
|remote_host_cidr|string|サーバへのSSH接続を許可するCIDRを指定|
|flavor|string|作成するインスタンスのフレーバーを指定|

## セキュリティグループ

### インスタンス１

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|ICMP                                |●|－|remote_host_cidr           |ICMP |
|ICMP                                |－|●|0.0.0.0/0                  |ICMP |
|SSH(TCP)                            |●|－|remote_host_cidr           |SSH  |
|HTTP(TCP)                           |－|●|0.0.0.0/0                  |HTTP |
|HTTPS(TCP)                          |－|●|0.0.0.0/0                  |HTTPS|
|TCP                                 |－|●|dns_nameservers,0          |DNS  |
|TCP                                 |－|●|dns_nameservers,1          |DNS  |
|UDP                                 |－|●|dns_nameservers,0          |DNS  |
|UDP                                 |－|●|dns_nameservers,1          |DNS  |
|TCP                                 |－|●|169.254.169.254/32         |HTTP |
|TCP（DB通信用)                      |●|－|ci-subnet CIDR      |3306 |
|TCP（DB通信用)                      |●|－|validate-subnet CIDR|3306 |
|TCP（DB通信用)                      |－|●|validate-subnet CIDR|3306 |
|TCP（クラスタレプリケーション通信用)|●|－|ci-subnet CIDR      |4567 |
|TCP（クラスタレプリケーション通信用)|●|－|validate-subnet CIDR|4567 |
|TCP（クラスタレプリケーション通信用)|－|●|validate-subnet CIDR|4567 |
|TCP（状態更新通信用)                |●|－|ci-subnet CIDR      |4568 |
|TCP（状態更新通信用)                |●|－|validate-subnet CIDR|4568 |
|TCP（状態更新通信用)                |－|●|validate-subnet CIDR|4568 |
|TCP（その他スナップショット通信用)  |●|－|ci-subnet CIDR      |4444 |
|TCP（その他スナップショット通信用)  |●|－|validate-subnet CIDR|4444 |
|TCP（その他スナップショット通信用)  |－|●|validate-subnet CIDR|4444 |

### インスタンス２

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|ICMP                                |●|－|remote_host_cidr           |ICMP |
|ICMP                                |－|●|0.0.0.0/0                  |ICMP |
|SSH(TCP)                            |●|－|remote_host_cidr           |SSH  |
|HTTP(TCP)                           |－|●|0.0.0.0/0                  |HTTP |
|HTTPS(TCP)                          |－|●|0.0.0.0/0                  |HTTPS|
|TCP                                 |－|●|dns_nameservers,0          |DNS  |
|TCP                                 |－|●|dns_nameservers,1          |DNS  |
|UDP                                 |－|●|dns_nameservers,0          |DNS  |
|UDP                                 |－|●|dns_nameservers,1          |DNS  |
|TCP                                 |－|●|169.254.169.254/32         |HTTP |
|TCP（DB通信用)                      |●|－|ci-subnet CIDR      |3306 |
|TCP（DB通信用)                      |●|－|validate-subnet CIDR|3306 |
|TCP（DB通信用)                      |－|●|validate-subnet CIDR|3306 |
|TCP（クラスタレプリケーション通信用)|●|－|ci-subnet CIDR      |4567 |
|TCP（クラスタレプリケーション通信用)|●|－|validate-subnet CIDR|4567 |
|TCP（クラスタレプリケーション通信用)|－|●|validate-subnet CIDR|4567 |
|TCP（状態更新通信用)                |●|－|ci-subnet CIDR      |4568 |
|TCP（状態更新通信用)                |●|－|validate-subnet CIDR|4568 |
|TCP（状態更新通信用)                |－|●|validate-subnet CIDR|4568 |
|TCP（その他スナップショット通信用)  |●|－|ci-subnet CIDR      |4444 |
|TCP（その他スナップショット通信用)  |●|－|validate-subnet CIDR|4444 |
|TCP（その他スナップショット通信用)  |－|●|validate-subnet CIDR|4444 |

## 出力情報

両インスタンスのIPアドレスを`http://xxx.xxx.xxx.xxx`形式で出力

## 起動方法

出力情報のインスタンス１IPアドレスにブラウザからアクセス

## その他
