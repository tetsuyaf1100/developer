# K5 IaaS Heat テンプレート集

## アプリケーション系

### CentOS 6 ベース
| テンプレート概要 | テンプレートファイル |
| :--------------- | :------------------- |
| インスタンスを作成し、Activitiをインストールします。TomcatをPROXYサーバとしてインストールします。[[詳細へ]](Applications/activiti_single_c6.yaml.md) | [activiti_single_c6.yaml](Applications/activiti_single_c6.yaml)	|
| インスタンスを作成し、Aipoをインストールします。 [[詳細へ]](Applications/aipo_single_c6.yaml.md) | [aipo_single_c6.yaml](Applications/aipo_single_c6.yaml) |
| インスタンスを作成し、Beats（Topbeat、Filebeat、Packetbeatの3種）をインストールします。検索、解析用にElasticsearch、データの可視化用にKibanaをインストールします。[[詳細へ]](Applications/beats_single_c6.yaml.md) | [beats_single_c6.yaml](Applications/beats_single_c6.yaml) |
| インスタンスを2つ用意し、インスタンス1にはDrupal、Apache、MariaDBクライアントを、インスタンス2にはMariaDBサーバをインストールします。両サーバ間を連携させます。[[詳細へ]](Applications/drupal_apache_mariadb_multi_c6.yaml.md) | [drupal_apache_mariadb_multi_c6.yaml](Applications/drupal_apache_mariadb_multi_c6.yaml) |
| インスタンスを作成し、Drupal、Apache、MariaDBをインストールします。[[詳細へ]](Applications/drupal_apache_single_c6.yaml.md) | [drupal_apache_single_c6.yaml](Applications/drupal_apache_single_c6.yaml) |
| インスタンスを２つ用意し、インスタンス１にはDrupal、Nginx、MariaDBクライアントを、インスタンス2にはMariaDBサーバをインストールします。両サーバ間を連携させます。[[詳細へ]](Applications/drupal_nginx_mariadb_multi_c6.yaml.md) | [drupal_nginx_mariadb_multi_c6.yaml](Applications/drupal_nginx_mariadb_multi_c6.yaml) |
| インスタンスを作成し、Drupal、Nginx、MariaDBをインストールします。[[詳細へ]](Applications/drupal_nginx_single_c6.yaml.md) | [drupal_nginx_single_c6.yaml](Applications/drupal_nginx_single_c6.yaml) |
| インスタンスを作成し、GitLabをインストールします。[[詳細へ]](Applications/gitlab_single_c6.yaml.md) | [gitlab_single_c6.yaml](Applications/gitlab_single_c6.yaml) |
| MariaDBを2つのインスタンスにインストールし、クラスタ化します。[[詳細へ]](Applications/mariadb_galeracluster_multi_c6.yaml.md) | [mariadb_galeracluster_multi_c6.yaml](Applications/mariadb_galeracluster_multi_c6.yaml) |
| インスタンスを作成し、MatterMost、Nginx、MySQLをインストールします。[[詳細へ]](Applications/mattermost_single_c6.yaml.md) | [mattermost_single_c6.yaml](Applications/mattermost_single_c6.yaml) |
| インスタンスを作成し、MySQLをインストールします。[[詳細へ]](Applications/mysql_single_c6.yaml.md) | [mysql_single_c6.yaml](Applications/mysql_single_c6.yaml) |
| インスタンスを作成し、Neo4jをインストールします。[[詳細へ]](Applications/neo4j_single_c6.yaml.md) | [neo4j_single_c6.yaml](Applications/neo4j_single_c6.yaml) |
| インスタンスを作成し、Openmeetings、JDK、MySQL、ImageMagick、GhostScript、SWFTools、LibreOffice、LAME、FFmpegをインストールします。[[詳細へ]](Applications/openmeetings_single_c6.yaml.md) | [openmeetings_single_c6.yaml](Applications/openmeetings_single_c6.yaml) |
| PostgreSQLを3つのインスタンスにインストールし、クラスタ化します。[[詳細へ]](Applications/postgresql_cluster_multi_c6.yaml.md) | [postgresql_cluster_multi_c6.yaml](Applications/postgresql_cluster_multi_c6.yaml) |
| インスタンスを作成し、Redmine及び周辺パッケージをインストールします。[[詳細へ]](Applications/redmine_single_c6.yaml.md) | [redmine_single_c6.yaml](Applications/redmine_single_c6.yaml) |
| インスタンスを作成し、SugarCRM、PHP、MariaDB、Apacheをインストールします。[[詳細へ]](Applications/sugarcrm_ce_single_c6.yaml.md) | [sugarcrm_ce_single_c6.yaml](Applications/sugarcrm_ce_single_c6.yaml) |

## プラットフォーム系

### CentOS 6 ベース
| テンプレート概要 | テンプレートファイル |
| :--------------- | :------------------- |
| インスタンスを2つ用意します。それぞれにWebサーバ（Apache）とNode.jsをインストールし、両サーバ間を連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](Applications/apache_nodejs_multi_c6.yaml.md) | [apache_nodejs_multi_c6.yaml](Applications/apache_nodejs_multi_c6.yaml) |
| インスタンスを2つ用意します。それぞれにWebサーバ（Apache）とAppサーバ（Tomcat）をインストールし、両サーバ間を連携させます。[[詳細へ]](Applications/apache_tomcat_multi_c6.yaml.md) | [apache_tomcat_multi_c6.yaml](Applications/apache_tomcat_multi_c6.yaml) |
| インスタンスを2つ用意します。それぞれにWebサーバ（Nginx）とNode.jsをインストールし、両サーバ間を連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](Applications/nginx_nodejs_multi_c6.yaml.md) | [nginx_nodejs_multi_c6.yaml](Applications/nginx_nodejs_multi_c6.yaml) |
| インスタンスを2つ用意します。それぞれにWebサーバ（Nginx）とAppサーバ（Tomcat）をインストールし、両サーバ間を連携させます。[[詳細へ]](Applications/nginx_tomcat_multi_c6.yaml.md) | [nginx_tomcat_multi_c6.yaml](Applications/nginx_tomcat_multi_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Apache）、Node.jsをインストールし、連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](Applications/apache_nodejs_single_c6.yaml.md) | [apache_nodejs_single_c6.yaml](Applications/apache_nodejs_single_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Apache）とAppサーバ（Tomcat）を作成し、連携させます。[[詳細へ]](Applications/apache_tomcat_single_c6.yaml.md) | [apache_tomcat_single_c6.yaml](Applications/apache_tomcat_single_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Nginx）、Node.jsをインストールし、連携させます。Node.js上で機能する簡易Appサーバを配置します。[[詳細へ]](Applications/nginx_nodejs_single_c6.yaml.md) | [nginx_nodejs_single_c6.yaml](Applications/nginx_nodejs_single_c6.yaml) |
| 1つのインスタンス上にWebサーバ（Nginx）とAppサーバ（Tomcat）を作成し、連携させます。[[詳細へ]](Applications/nginx_tomcat_single_c6.yaml.md) | [nginx_tomcat_single_c6.yaml](Applications/nginx_tomcat_single_c6.yaml) |
