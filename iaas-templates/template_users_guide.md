# IaaSテンプレート利用ガイド

## 本書の目的

公開済みのIaaSテンプレートを使用して、スタックを作成する為の手順を示します。  

## 前提

K5上のアカウントが以下のロールを有している必要があります。

- 設計・構築者ロール(cpf_systemowner)※ロールについては機能説明書を、ロールの設定方法についてはAPIリファレンスを参照して下さい。

## 参考資料

- FUJITSU Cloud Service K5 IaaS 機能説明書
- FUJITSU Cloud Service K5 IaaS API リファレンス
- FUJITSU Cloud Service K5 IaaS API ユーザーズガイド
- FUJITSU Cloud Service K5 IaaS サービスポータルユーザーズガイド

## 手順

### テンプレートファイルのダウンロード
1. [テンプレート一覧のページ](https://github.com/k5-community/developer/tree/master/iaas-templates)を開きます。

1. 利用したいテンプレートファイルのリンクをクリックします。  
  例えば、apache_tomcat_single_c6_select.yamlを利用したい場合は、以下の赤枠をクリックします。  
  ![template_list_page](./images/apache_tomcat_single_c6_select.jpg)

1. テンプレートのページが表示されるので、「Raw」を右クリック後、「名前を付けてリンク先を保存」を選択し、ファイルとして保存します。

### スタックの作成

1. K5のIaaSポータルにログインします。

1. 作成対象のリージョン及びプロジェクトを選択します。

1. メニューの「テンプレート＞スタック」をクリックします。  
  ![stack_menu_select](./images/stack_menu_select.jpg)

1. 右上の「＋」をクリックし、スタック作成画面を表示します。  
  ![new_stack_button](./images/new_stack_button.jpg)

1. スタック名を指定します。既存のスタックと重複しないように注意して下さい。  
  ![stack_name_input](./images/stack_name_input.jpg)

1. テンプレート指定方法でファイルを選択します。  
  ![template_type_select](./images/template_type_select.jpg)

1. 「テンプレートファイルのダウンロード」で保存したファイルをドラッグ＆ドロップします。  
  ![template_file_droped](./images/template_file_droped.jpg)

1. 右上の「パラメータ設定」をクリックし、パラメータ設定画面を表示します。  
  ![parameters_setting_button](./images/parameters_setting_button.jpg)

1. 各パラメータを入力します。  
  各パラメータの詳細については、テンプレート一覧から該当テンプレートの「詳細へ」をクリックし  
  ![md_link](./images/md_link.jpg)  
  リンク先のテンプレート説明用mdファイル内の「作成時パラメタ」を参照して下さい。  
  ![parameters_list](./images/parameters_list.jpg)  
  以下は、入力例になります。  
  ![parameters_set](./images/parameters_set.jpg)  
  入力したパラメータはチェック状態にして下さい。

1. 「設定」をクリックします。  
  ![parameters_set_button](./images/parameters_set_button.jpg)

1. 確認メッセージが表示されるので、「設定」をクリックし、スタック作成画面に戻ります。  
  ![parameters_set_dialog](./images/parameters_set_dialog.jpg)

1. 右上の「作成」をクリックします。  
  ![create_stack_button](./images/create_stack_button.jpg)

1. 受付完了のメッセージが表示されたら「閉じる」をクリックします。※表示まで時間がかかる場合があります。  
  ![create_request_complete_dialog](./images/create_request_complete_dialog.jpg)

1. スタック一覧のページで、指定したスタック名のものが「CREATE_IN_PROGRESS」になっている事を確認します。  
  ![create_progress](./images/create_progress.jpg)

1. 何度かページの更新を行い、「CREATE_COMPLETE」と表示されれば、スタックの作成が完了しています。  
  ![create_complete](./images/create_complete.jpg)
