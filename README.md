# README

このリポジトリは Rails アプリケーションを素早く作成するためのテンプレートです。
clone 後に `.git` を削除して新規アプリケーションのベースとして利用してください。

## git の設定をリセットする手順

```bash
rm -rf .git
git init
git add .
git commit -m "Initial commit"
```

任意のリモートリポジトリを追加して開発を開始します。

## 開発環境

- Ruby 3.4.4 / Rails 8.0.2
- [dip](https://github.com/bibendi/dip) + docker compose
  - VS Code の DevContainer を用いる場合は `dip up` を使わず、
    起動後に `bin/dev` を実行してください。

初回起動時は次のコマンドで環境を準備します。

```bash
bin/setup
bin/dev
```

## 設定の概要

### Database

デフォルトで PostgreSQL を使用し、マイグレーション管理には
[ridgepole](https://github.com/ridgepole/ridgepole) を採用しています。
`db/schema/` 以下に `.schema` ファイルを置くとスキーマが適用されます。

### 非同期処理

Rails 8 標準の `solid_queue` を利用します。
ジョブの状態は MissionControl の UI から確認できます。
コンテナ上では `bin/jobs` を別プロセスで起動してください。

### ページネーション・検索

[kaminari](https://github.com/kaminari/kaminari) と
[ransack](https://github.com/activerecord-hackery/ransack) を同梱しています。

### CSS

[tailwindcss-rails](https://github.com/rails/tailwindcss-rails) により
ファイル変更時は自動で再ビルドされます。

### JavaScript

Hotwire(Turbo/Stimulus) と importmap を利用しているため
`node_modules` は不要です。

### View

テンプレートエンジンは Haml を採用し、
[ViewComponent](https://github.com/ViewComponent/view_component) も利用できます。

### メール

開発環境では [letter_opener_web](https://github.com/fgrehm/letter_opener_web)
でメール内容をブラウザ確認できます。

### 例外通知

[exception_notification](https://github.com/smartinez87/exception_notification)
と `slack-notifier` により Slack へエラーを通知できます。

### 環境変数

`rails credentials` を利用します。`config/master.key` を取得して配置してください。

## Debug

VS Code でのデバッグ方法は
[こちら](https://corporate.irori.dev/posts/rails-debug-devcontainer-with-foreman)
を参照してください。

## サンプル実装

`users` と `admins` のリソースを簡易的に実装しています。
ログインやメール送信の仕組みなどを確認するサンプルとして利用してください。
