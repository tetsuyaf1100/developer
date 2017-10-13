# K5 IaaS Heat テンプレート集

[\[利用方法\]](usage.md)

## アプリケーション系

### CentOS 6 ベース

| テンプレート概要 | テンプレートファイル |
| :--------------- | :------------------- |
| インスタンスを作成し、Activitiをインストールします。TomcatをPROXYサーバとしてインストールします。[[詳細へ]](applications/activiti_single_c6.md) | [activiti_single_c6.yaml](applications/activiti_single_c6.yaml) |
| インスタンスを作成し、Aipoをインストールします。 [[詳細へ]](applications/aipo_single_c6.md) | [aipo_single_c6.yaml](applications/aipo_single_c6.yaml) |
| インスタンスを作成し、Beats（Topbeat、Filebeat、Packetbeatの3種）をインストールします。検索、解析用にElasticsearch、データの可視化用にKibanaをインストールします。[[詳細へ]](applications/beats_single_c6.md) | [beats_single_c6.yaml](applications/beats_single_c6.yaml) |
| インスタンスを2つ用意し、インスタンス1にはDrupal、Apache、MariaDBクライアントを、インスタンス2にはMariaDBサーバをインストールします。両サーバ間を連携させます。[[詳細へ]](applications/drupal_apache_mariadb_multi_c6.md) | [drupal_apache_mariadb_multi_c6.yaml](applications/drupal_apache_mariadb_multi_c6.yaml) |
| インスタンスを作成し、Drupal、Apache、MariaDBをインストールします。[[詳細へ]](applications/drupal_apache_single_c6.md) | [drupal_apache_single_c6.yaml](applications/drupal_apache_single_c6.yaml) |
| インスタンスを２つ用意し、インスタンス１にはDrupal、Nginx、MariaDBクライアントを、インスタンス2にはMariaDBサーバをインストールします。両サーバ間を連携させます。[[詳細へ]](applications/drupal_nginx_mariadb_multi_c6.md) | [drupal_nginx_mariadb_multi_c6.yaml](applications/drupal_nginx_mariadb_multi_c6.yaml) |
| インスタンスを作成し、Drupal、Nginx、MariaDBをインストールします。[[詳細へ]](applications/drupal_nginx_single_c6.md) | [drupal_nginx_single_c6.yaml](applications/drupal_nginx_single_c6.yaml) |
| インスタンスを作成し、GitLabをインストールします。[[詳細へ]](applications/gitlab_single_c6.md) | [gitlab_single_c6.yaml](applications/gitlab_single_c6.yaml) |
| MariaDBを2つのインスタンスにインストールし、クラスタ化します。[[詳細へ]](applications/mariadb_galeracluster_multi_c6.md) | [mariadb_galeracluster_multi_c6.yaml](applications/mariadb_galeracluster_multi_c6.yaml) |
| インスタンスを作成し、MatterMost、Nginx、MySQLをインストールします。[[詳細へ]](applications/mattermost_single_c6.md) | [mattermost_single_c6.yaml](applications/mattermost_single_c6.yaml) |
| インスタンスを作成し、MySQLをインストールします。[[詳細へ]](applications/mysql_single_c6.md) | [mysql_single_c6.yaml](applications/mysql_single_c6.yaml) |
| インスタンスを作成し、Neo4jをインストールします。[[詳細へ]](applications/neo4j_single_c6.md) | [neo4j_single_c6.yaml](applications/neo4j_single_c6.yaml) |
| インスタンスを作成し、Openmeetings、JDK、MySQL、ImageMagick、GhostScript、SWFTools、LibreOffice、LAME、FFmpegをインストールします。[[詳細へ]](applications/openmeetings_single_c6.md) | [openmeetings_single_c6.yaml](applications/openmeetings_single_c6.yaml) |
| PostgreSQLを3つのインスタンスにインストールし、クラスタ化します。[[詳細へ]](applications/postgresql_cluster_multi_c6.md) | [postgresql_cluster_multi_c6.yaml](applications/postgresql_cluster_multi_c6.yaml) |
| インスタンスを作成し、Redmine及び周辺パッケージをインストールします。[[詳細へ]](applications/redmine_single_c6.md) | [redmine_single_c6.yaml](applications/redmine_single_c6.yaml) |
| インスタンスを作成し、SugarCRM、PHP、MariaDB、Apacheをインストールします。[[詳細へ]](applications/sugarcrm_ce_single_c6.md) | [sugarcrm_ce_single_c6.yaml](applications/sugarcrm_ce_single_c6.yaml) |

## プラットフォーム系

### CentOS 6 ベース

| テンプレート概要 | テンプレートファイル |
| :--------------- | :------------------- |
| インスタンスを2つ用意します。それぞれにWebサーバ（Apache）とNode.jsをインストールし、両サーバ間を連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](platforms/apache_nodejs_multi_c6.md) | [apache_nodejs_multi_c6.yaml](platforms/apache_nodejs_multi_c6.yaml) |
| インスタンスを2つ用意します。それぞれにWebサーバ（Apache）とAppサーバ（Tomcat）をインストールし、両サーバ間を連携させます。[[詳細へ]](platforms/apache_tomcat_multi_c6.md) | [apache_tomcat_multi_c6.yaml](platforms/apache_tomcat_multi_c6.yaml) |
| インスタンスを2つ用意します。それぞれにWebサーバ（Nginx）とNode.jsをインストールし、両サーバ間を連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](platforms/nginx_nodejs_multi_c6.md) | [nginx_nodejs_multi_c6.yaml](platforms/nginx_nodejs_multi_c6.yaml) |
| インスタンスを2つ用意します。それぞれにWebサーバ（Nginx）とAppサーバ（Tomcat）をインストールし、両サーバ間を連携させます。[[詳細へ]](platforms/nginx_tomcat_multi_c6.md) | [nginx_tomcat_multi_c6.yaml](platforms/nginx_tomcat_multi_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Apache）、Node.jsをインストールし、連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](platforms/apache_nodejs_single_c6.md) | [apache_nodejs_single_c6.yaml](platforms/apache_nodejs_single_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Apache）とAppサーバ（Tomcat）を作成し、連携させます。[[詳細へ]](platforms/apache_tomcat_single_c6.md) | [apache_tomcat_single_c6.yaml](platforms/apache_tomcat_single_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Nginx）、Node.jsをインストールし、連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](platforms/nginx_nodejs_single_c6.md) | [nginx_nodejs_single_c6.yaml](platforms/nginx_nodejs_single_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Nginx）とAppサーバ（Tomcat）を作成し、連携させます。[[詳細へ]](platforms/nginx_tomcat_single_c6.md) | [nginx_tomcat_single_c6.yaml](platforms/nginx_tomcat_single_c6.yaml) |
