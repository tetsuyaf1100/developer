Neo4j シングルインスタンス<br>テンプレート概要説明
====

<br>

### 概要

インスタンスを作成し、Neo4jをインストールします。

<br>

### 作成されるシステムの構成図

![構成図](images/diag_single.png)

<br>

### インスタンスの詳細

|項目|内容|
|---|---|
|OS|CentOS 6.5 64bit|
|イメージタイプ|CentOS 6.5 64bit (English) 05|
|フレーバータイプ|S-1|
|ボリュームタイプ|M1|

<br>

#### インストールするソフトウェア

|ソフトウェア|バージョン|ライセンス|説明|
|---|---|---|---|
|Neo4j|3.0.6|[GPLv3](https://www.gnu.org/licenses/quick-guide-gplv3.html)|グラフDB|
|JDK|1.8.0 102|[Oracle Binary Code License (BCL)](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)|JDK|

<br>

### 作成方法

[IaaSテンプレート利用ガイド](https://github.com/k5-community/developer/tree/master/iaas-templates/template_users_guide.md)を参照して下さい。

<br>

### 作成時パラメタ

|パラメタ名|入力する値の型|説明|
|---|---|---|
|keypair_name|string|使用する証明書の鍵を指定|
|availability_zone|string|アベイラビリティーゾーンを指定|
|dns_nameservers|comma_delimited_list|DNSネームサーバを指定<br>`['xxx.xxx.xxx.xxx', 'yyy.yyy.yyy.yyy']`形式|
|network_id|string|インスタンスが所属するネットワークIDを指定|
|subnet_id|string |インスタンスが所属するサブネットIDを指定|
|remote_host_cidr|string|サーバへのSSH接続を許可するCIDRを指定|
|flavor|string|作成するインスタンスのフレーバーを指定|

<br>

### セキュリティグループ

|プロトコル|ingress|egress|対象IPアドレス|ポート|
|---|---|---|---|---|
|ICMP      |●|－|remote_host_cidr  |ICMP |
|SSH(TCP)  |●|－|remote_host_cidr  |SSH  |
|HTTP(TCP) |－|●|0.0.0.0/0         |HTTP |
|HTTPS(TCP)|－|●|0.0.0.0/0         |HTTPS|
|TCP       |－|●|dns_nameservers,0 |DNS  |
|TCP       |－|●|dns_nameservers,1 |DNS  |
|UDP       |－|●|dns_nameservers,0 |DNS  |
|UDP       |－|●|dns_nameservers,1 |DNS  |
|TCP       |－|●|169.254.169.254/32|HTTP |

<br>

### 出力情報

インスタンスのIPアドレスを`http://xxx.xxx.xxx.xxx`形式で出力

<br>

### 起動方法

出力情報のIPアドレスにブラウザからアクセス

<br>

### その他

---
