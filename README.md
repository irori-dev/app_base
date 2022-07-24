# README

Railsアプリケーションを作成するための土台となるリポジトリです。
このリポジトリをcloneし、gitの設定をresetして新しいapplicationの作成時に活用してください。

## gitの設定のreset方法
ドキュメンテーションします

## 開発環境

[dip](https://github.com/bibendi/dip)を使用して`docker compose`をwrapperしています。


## 設定の仕様

### Database
migrationファイルが無数にできるのが嫌なので、[ridgepole](https://github.com/ridgepole/ridgepole)というgemを使用しています。
`/db/schema/`以下に`.schema`拡張子でファイルを作成するとそのファイルを読み込んでDBを作成します。
書き方はmigrationファイルと似ているのでそこまでてこずらないと思います。

### 非同期処理
redis, sidekiqが入っています。
特筆すべきことはないと思います。

### ページネーション、検索
[kaminari]()と[ransack]()を入れています。
メジャーどころなのでたくさん記事があると思います。

### CSS
Tailwind CSS が入っています。hotreloadしてくれるので便利。

### JS
Rails7らしく、Hotwireに全のりしています。
importmap-railsがベースなのでnode_modulesは必要ありません。幸せ。

### 環境変数
`dotenv-rails`を使用しています。

### view
hamlを使用しています。

## サンプル実装

`cats`のresourcesを作成しています。
参考にしてみてください。

## TODO
- [ ] Tailwindのoddが効かない件の調査
- [ ] rubocopの設定
- [ ] RSpec
- [ ] ViewComponent周りの設定
- [ ] CIの設定
- [ ] ドキュメンテーション

