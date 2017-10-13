# 死活監視自動実行

## アプリケーションの死活監視と自動再起動

CFを使ってアプリケーションを動かすメリットとして、
以下のような機能があげられます。

- アプリケーションの死活監視を自動的に実現
- 監視で異常終了が確認されたアプリケーションを自動的に再起動

CFを利用してアプリケーションを動かすことで、
運用管理者は自前で死活監視や異常終了したインスタンスを
自動起動する仕掛けを用意する苦労から解放されます。

## 死活監視と自動再起動機能の確認

CF が各インスタンスの死活監視を自動的に行っていること、
異常終了したインスタンスを自動的に再起動していることを、
実際にアプリケーションとコマンドを使って、確認してみましょう。

1. テストアプリケーションの作成

   以下のソースコードを使って、テストアプリケーション
   ”AppTest001”を作り、CFにデプロイします。

   AppTest001は、呼び出されると、”自分に割り付けられた
   IPアドレス”な文字列を返すアプリケーションです。

   AppTest001はSpring Boot Actuatorのシャットダウン
   機能を有効にしてあります。“AppTest001.xxxx…/shutdown”
   にアクセスすることで自分自身（インスタンス）が終了します。

   CFへのログイン方法、テストアプリケーションのCFへの
   デプロイ方法は、「K5 CF チュートリアル」等を参照してください。

   ```
   package com.example;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.web.bind.annotation.RequestMapping;
   import org.springframework.web.bind.annotation.RestController;

   @SpringBootApplication
   @RestController
   public class HelloPwsApplication {

       @RequestMapping("/")
       String hello() {
           return System.getenv("CF_INSTANCE_ADDR");
       }

       public static void main(String[] args) {
           SpringApplication.run(HelloPwsApplication.class, args);
       }
   }
   ```

1. 状態確認（インスタンス数変更前）

   ”AppTest001”をCFにデプロイしたのち、アプリケーション
   の配備状態を確認するためのコマンド”cf apps”を実行すると
   以下のような応答が返ります。

   ```
   name        requested state instances   memory  disk    urls
   AppTest001  started         1/1         1G      1G      AppTest001.xxxx…
   ```

   requested state が started で、instances が 1/1 なので、
   インスタンスが一つ起動されていることがわかります。

1. インスタンス数変更

   死活監視されている様子をよくわかるようにするため、
   AppTest001のインスタンスを2つに増やします。

   ```
   $ cf scale AppTest001 -i 4
   ```

1. アプリケーション実行（インスタンスshutdown前）

   この状態で、複数回AppTest001を呼び出すと、
   同じURLでアクセスしているにも関わらず、
   2種類の異なる毎IPアドレスの文字列が返ってきます。

   ```
   $ for i in `seq 1 10`; do curl http://AppTest001.xxxx…; done
   10.10.115.78:62878
   10.10.115.91:60224
   10.10.115.78:62878
   10.10.115.91:60224
   10.10.115.78:62878
   10.10.115.91:60224
   ```

1. インスタンスのshutdown実行

   ここで以下のコマンドを一回だけ実行（２つ動いている
   インスタンスのうち、一方の shutdown 機能を呼び出し）
   します。

   ```
   $ curl http://AppTest001.xxxx…/shutdown
   ```

   上記を行うと、インスタンスがCFの知らない世界で
   勝手にシャットダウンし、CFにとってはインスタンスが
   異常終了したように見えます。

1. アプリケーション実行（インスタンスshutdown後）

   上記コマンド実施直後に、複数回AppTest001を呼び出すと、
   １つの同じIPアドレスの文字列が返ってきます。

   ```
   $ for i in `seq 1 10`; do curl http://AppTest001.xxxx…; done
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.91:60224
   ```

   更にしばらくしてから同様に複数回AppTest001を呼び出すと、
   同じURLでアクセスしているにも関わらず、2つの異なる
   IPアドレスが返ってくる状態となり「同じURLで２つの異なる
   インスタンスにアクセスしている = 先ほど強制終了させた
   インスタンスが自動的に再起動された」ことがわかります。

   ```
   $ for i in `seq 1 10`; do curl http://AppTest001.xxxx…; done
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.91:60224
   10.10.115.55:62811
   10.10.115.91:60224
   10.10.115.55:62811
   10.10.115.91:60224
   10.10.115.55:62811
   10.10.115.91:60224
   ```

## 確認結果から見える死活監視と自動再起動機能

この結果から分かるように、CF上で動作している
アプリケーションのインスタンスは、運用管理者が
何もせずとも死活監視され、異常終了した場合は、
自動的に再起動されます。

もしこれがCFのない世界だったら、どのような対応が
想定されるでしょうか？
まず、自前で死活監視の仕組みを作る必要があります。
死活監視対象が何か登録する作業も必要でしょう。
新しいインスタンスを立ち上げるために、それも死活監視
対象とみなすように登録する作業もいるかもしれません。
またインスタンスが異常終了した場合、再起動する
仕掛けも作成する必要があるでしょう。

こうした運用管理上の手間をCFはすべて吸収してくれます。
