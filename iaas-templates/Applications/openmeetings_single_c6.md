# Openmeetings シングルインスタンス テンプレート概要説明

## 概要

インスタンスを作成し、Openmeetings、JDK、MySQL、ImageMagick、GhostScript、SWFTools、LibreOffice、LAME、FFmpegをインストールします。

## 作成されるシステムの構成図

![構成図](images/diag_single.png)

## インスタンスの詳細

|項目|内容|
|---|---|
|OS|CentOS 6.5 64bit|
|イメージタイプ|CentOS 6.5 64bit (English) 05|
|フレーバータイプ|S-1|
|ボリュームタイプ|M1|

### インストールするソフトウェア

|ソフトウェア|バージョン|ライセンス|説明|
|---|---|---|---|
|Openmeetings|3.1.3|[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)|グループウェア|
|JDK|1.8.0 102|[Oracle Binary Code License (BCL)](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)|JDK|
|MySQL|最新|[GPL または Commercial License](https://ja.wikipedia.org/wiki/MySQL)|MySQL devel、server、utility<br>yumインストール<br>ライセンスに関して要注意|
|ImageMagick|最新パッケージ|[独自](https://www.imagemagick.org/script/license.php)|画像編集<br>yumインストール|
|GhostScript|最新パッケージ|[AGPL](http://www.artifex.com/page/licensing-information.html)|ラスタイメージプロセッサ<br>yumインストール|
|SWFTools|0.9.2|[GPL version 2](http://www.gnu.org/licenses/gpl2.html)|Flash編集アプリ|
|LibreOffice|5.1.5|[Mozilla Public License v2.0](https://www.mozilla.org/MPL/)|Office系アプリ|
|LAME|3.99.5|[LGPL](http://lame.sourceforge.net/license.txt)|MP3エンコーダ|
|FFmpeg|3.1.4|[GNU Lesser General Public License (LGPL) version 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)|MPEGエンコーダ|

## 作成方法

[IaaSテンプレート利用ガイド](../usage.md)を参照して下さい。

## 作成時パラメタ

|パラメタ名|入力する値の型|説明|
|---|---|---|
|keypair_name|string|使用する証明書の鍵を指定|
|availability_zone|string|アベイラビリティーゾーンを指定|
|dns_nameservers|comma_delimited_list|DNSネームサーバを指定<br>`['xxx.xxx.xxx.xxx', 'yyy.yyy.yyy.yyy']`形式|
|network_id|string|インスタンスが所属するネットワークIDを指定|
|subnet_id|string |インスタンスが所属するサブネットIDを指定|
|remote_host_cidr|string|サーバへのSSH接続を許可するCIDRを指定|
|flavor|string|作成するインスタンスのフレーバーを指定|

## セキュリティグループ

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
|TCP       |●|－|0.0.0.0/0         |5080 |
|TCP       |－|●|0.0.0.0/0         |5080 |

## 出力情報

インスタンスのIPアドレスを`http://xxx.xxx.xxx.xxx`形式で出力

## 起動方法

出力情報のIPアドレスにブラウザからアクセス

## その他
