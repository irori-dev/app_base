# README

Railsアプリケーションを作成するための土台となるリポジトリです。
このリポジトリをcloneし、gitの設定をresetして新しいapplicationの作成時に活用してください。

## gitの設定のreset方法

ドキュメンテーションします

## 開発環境

[dip](https://github.com/bibendi/dip)を使用して`docker compose`をwrapperしています。
(VS Codeを使用している場合はdip upは使用しない方がいいです。Debugの項目を見てみてください。)

## 設定の仕様

### Database

migrationファイルが無数にできるのが嫌なので、[ridgepole](https://github.com/ridgepole/ridgepole)というgemを使用しています。
`/db/schema/`以下に`.schema`拡張子でファイルを作成するとそのファイルを読み込んでDBを作成します。
書き方はmigrationファイルと似ているのでそこまでてこずらないと思います。

### 非同期処理

redis, sidekiqが入っています。
特筆すべきことはないと思います。

### ページネーション、検索

[kaminari](https://github.com/kaminari/kaminari)と[ransack](https://github.com/activerecord-hackery/ransack)を入れています。
メジャーどころなのでたくさん記事があると思います。

### CSS

Tailwind CSS が入っています。hotreloadしてくれるので便利。

### JS

Rails7らしく、Hotwireに全のりしています。
importmap-railsがベースなのでnode_modulesは必要ありません。幸せ。

### view

hamlを使用しています。

### 環境変数

`rails:credentials`を使用しています。
`master.key`が必要になるので持っている人に聞いてください

## Debug

[こちら](https://corporate.irori.dev/posts/rails-debug-devcontainer-with-foreman)を参考にしてみてください。


## サンプル実装

`users`と`admins`のresourcesを作成しています。
参考にしてみてください。
