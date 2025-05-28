# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) へのガイダンスを提供します。

## 重要な開発ルール

### Docker環境での開発

- **必須**: このプロジェクトはDocker環境を前提としています
- すべてのコマンドはDockerコンテナ内で実行してください
- `docker compose exec app <command>` を使用するか、コンテナ内で直接実行

### コード品質チェック

- **必須**: コード変更後は必ず以下を実行してください：
  - `bin/rspec` - すべてのテストが通ることを確認
  - `bin/rubocop` - コーディング規約に準拠していることを確認

### テストの追加

- **必須**: 機能追加や修正を行った場合は、対応するspecファイルも追加・更新してください
- テストなしのコード変更は受け入れられません

## 基本コマンド

### 開発環境のセットアップ

```bash
# 依存関係のインストール
bundle install

# データベーススキーマの適用（マイグレーションの代わりにRidgepoleを使用）
bin/rails ridgepole:apply DATABASE=primary
bin/rails ridgepole:apply DATABASE=cache
bin/rails ridgepole:apply DATABASE=queue

# foremanを使用して開発サーバーを起動
bin/dev

# またはDockerで
docker compose up
```

### テスト

```bash
# すべてのテストを実行
bin/rspec

# 特定のテストファイルを実行
bin/rspec spec/path/to/test_spec.rb

# 特定のテストを実行
bin/rspec spec/path/to/test_spec.rb:line_number
```

### データベーススキーマ管理

このプロジェクトはRailsマイグレーションの代わりにRidgepoleを使用しています。スキーマファイルは `/db/schema/` にあります。

```bash
# スキーマ変更の適用
bin/rails ridgepole:apply DATABASE=primary

# ドライラン（何が変更されるかを表示）
bin/rails ridgepole:dry-run DATABASE=primary

# 現在のスキーマをエクスポート
bin/rails ridgepole:export DATABASE=primary
```

### コード品質

```bash
# コードスタイルのためのRuboCopを実行
bin/rubocop

# セキュリティ分析のためのBrakemanを実行
bin/brakeman
```

## アーキテクチャ概要

### マルチデータベース構成

アプリケーションは3つの独立したデータベースを使用しています：

- **primary**: メインアプリケーションデータ（ユーザー、管理者、連絡先）
- **cache**: Solid Cacheストレージ
- **queue**: Solid Queueジョブ処理

### 認証システム

- **ユーザー認証**: `app/models/user/core.rb` に配置され、パスワードリセット（`user/password_reset.rb`）とメール変更（`user/email_change.rb`）機能を含む
- **管理者認証**: `app/models/admin.rb` の独立したモデル
- 両方ともbcryptで `has_secure_password` を使用

### コンポーネントアーキテクチャ

- `app/components/` のUIコンポーネントにViewComponentを使用
- コンポーネントは名前空間で整理（admins/、users/、共有コンポーネント）
- 各コンポーネントはRubyクラスとHAMLテンプレートを持つ

### フロントエンドスタック

- **Hotwire**: SPA風のインタラクションのためのTurbo + Stimulus
- **Tailwind CSS**: ホットリロード付きのユーティリティファーストCSSフレームワーク
- **ImportMap**: node_modulesが不要、JavaScriptモジュールを直接提供

### バックグラウンドジョブ

- Redis/Sidekiqの代わりにSolid Queue（データベースベース）を使用
- `app/jobs/` のジョブクラス
- Mission Control経由でモニタリング可能

### テストアプローチ

- すべてのテストにRSpec
- テストデータ生成にFactoryBot
- SeleniumでのシステムテストにCapybara
- 外部APIモッキングにWebMock
- テストは実行前に自動的にRidgepoleスキーマを適用

### 主要ディレクトリ

- `/app/controllers/admins/`: ベース認証付きの管理者専用コントローラー
- `/app/controllers/users/`: ユーザー専用コントローラー
- `/app/views/svgs/`: HAMLパーシャルとしてのSVGアイコン
- `/db/schema/`: Ridgepole用のデータベーススキーマ定義

### 環境設定

- シークレット用にRails credentialsを使用
- 開発環境ではメールプレビュー用にLetter Openerを使用
- 本番環境では例外通知をSlackに送信
