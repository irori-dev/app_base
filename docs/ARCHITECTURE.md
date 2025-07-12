# アーキテクチャ概要

## 技術スタック

### バックエンド
- **Ruby 3.4.4** / **Rails 8.0.2**
- **PostgreSQL 16** - メインデータベース
- **Solid Suite** - Redis/Sidekiqの代替
  - Solid Cache - キャッシュストレージ
  - Solid Queue - バックグラウンドジョブ
  - Solid Cable - WebSocket接続

### フロントエンド
- **Hotwire** - SPA風のインタラクティブUI
  - Turbo - ページ遷移の高速化
  - Stimulus - JavaScriptフレームワーク
- **Tailwind CSS** - ユーティリティファーストCSS
- **ViewComponent** - コンポーネントベースのビュー構築
- **ImportMap** - node_modules不要のJS管理

### 開発ツール
- **Docker** - 開発環境の統一
- **Ridgepole** - スキーマ管理
- **RSpec** - テストフレームワーク
- **RuboCop** - コードスタイルチェック
- **Brakeman** - セキュリティスキャン
- **Bullet** - N+1クエリ検出

## ディレクトリ構造

```
app/
├── controllers/
│   ├── admins/          # 管理者用コントローラー
│   ├── users/           # ユーザー用コントローラー
│   └── concerns/        # 共通処理
├── models/
│   ├── user/            # User名前空間のモデル
│   │   ├── core.rb      # ユーザー基本情報
│   │   ├── email_change.rb
│   │   └── password_reset.rb
│   └── concerns/        # 共通処理
├── components/          # ViewComponent
│   ├── admins/          # 管理者用コンポーネント
│   ├── users/           # ユーザー用コンポーネント
│   └── shared/          # 共通コンポーネント
├── views/
│   └── svgs/            # SVGアイコン
└── jobs/                # バックグラウンドジョブ

db/
└── schema/              # Ridgepoleスキーマファイル
    ├── primary/         # メインDB
    ├── cache/           # キャッシュDB
    └── queue/           # ジョブキューDB
```

## データベース設計

### マルチデータベース構成

1. **Primary Database** - アプリケーションデータ
   - users (user_cores テーブル)
   - admins
   - contacts
   - user_password_resets
   - user_email_changes

2. **Cache Database** - Solid Cache用
   - solid_cache_entries

3. **Queue Database** - Solid Queue用
   - solid_queue_jobs
   - solid_queue_scheduled_executions
   - その他のキュー管理テーブル

### 主要モデルの関連

```ruby
# User名前空間
module User
  class Core < ApplicationRecord
    has_many :password_resets
    has_many :email_changes
  end
end

# 管理者
class Admin < ApplicationRecord
  # 独立した認証システム
end
```

## 認証システム

### デュアル認証

1. **ユーザー認証** (`User::Core`)
   - セッションベース認証
   - パスワードリセット機能
   - メールアドレス変更機能

2. **管理者認証** (`Admin`)
   - 独立したセッション管理
   - ユーザーとは完全に分離

### セキュリティ機能

- bcryptによるパスワードハッシュ化
- セキュアトークン生成（`Tokenizable`）
- 有効期限付きトークン（`ExpirableToken`）
- Strong Parameters
- Ransackable属性の制限

## 共通化された機能（Concerns）

### Models

1. **Authentication**
   - `has_secure_password`
   - メール/パスワードバリデーション
   - Ransackable属性の定義

2. **Tokenizable**
   - セキュアトークン生成
   - カスタマイズ可能なdigestカラム
   - エラーハンドリングオプション

3. **ExpirableToken**
   - 有効期限管理
   - 期限切れスコープ

### Controllers

1. **Authenticatable**
   - セッション管理
   - 認証要求/除外
   - current_user/admin管理

2. **SessionManageable**
   - ログイン/ログアウト処理
   - Strong Parameters

3. **Searchable**
   - Ransack検索の共通化
   - デフォルトソート設定
   - includesサポート

## フロントエンドアーキテクチャ

### Hotwire (Turbo + Stimulus)

- **Turbo Drive** - ページ遷移の高速化
- **Turbo Frames** - 部分更新
- **Turbo Streams** - リアルタイム更新
- **Stimulus** - 軽量JSフレームワーク

### ViewComponent

コンポーネントベースの設計により、再利用性とテスタビリティを向上：

```ruby
# app/components/modal/component.rb
class Modal::Component < ViewComponent::Base
  def initialize(id:)
    @id = id
  end
end
```

### Tailwind CSS

- ユーティリティファーストアプローチ
- カスタムCSSは最小限
- ホットリロード対応

## バックグラウンド処理

### Solid Queue

- データベースベースのジョブキュー
- Redisが不要
- Mission Controlでモニタリング可能

```ruby
class CreateSampleUsersJob < ApplicationJob
  def perform(count:)
    # ジョブ処理
  end
end
```

## 開発環境

### Docker構成

- **app** - Railsアプリケーション
- **postgres** - PostgreSQLデータベース
- **chrome** - システムテスト用

### 環境変数管理

- Rails credentialsを使用
- `config/master.key`で暗号化
- 環境別の設定可能

## テスト戦略

### テストの種類

1. **Request Specs** - APIレベルのテスト
2. **System Specs** - E2Eテスト
3. **Model Specs** - ビジネスロジック
4. **Component Specs** - UIコンポーネント

### テストツール

- RSpec - テストフレームワーク
- FactoryBot - テストデータ生成
- Capybara - 統合テスト
- WebMock - 外部API モック

## パフォーマンス最適化

1. **N+1クエリ対策**
   - Bulletによる自動検出
   - includesの適切な使用

2. **キャッシュ戦略**
   - Solid Cacheによるフラグメントキャッシュ
   - ロシアンドールキャッシング

3. **アセット最適化**
   - Propshaftによる効率的な配信
   - Tailwindの本番ビルド最適化

## セキュリティ

1. **認証・認可**
   - セッションベース認証
   - 管理者とユーザーの分離

2. **脆弱性対策**
   - Strong Parameters
   - CSRF対策
   - Brakemanによる定期スキャン

3. **依存関係管理**
   - Dependabotによる自動更新
   - セキュリティアップデートの迅速な適用

## 監視とログ

1. **例外通知**
   - Exception NotificationによるSlack通知
   - 本番環境のエラー追跡

2. **ログ管理**
   - 環境別のログレベル設定
   - Bulletログによるパフォーマンス監視

## 拡張ポイント

このベースリポジトリは以下の拡張を想定：

1. **API機能** - GraphQL/REST API追加
2. **多言語対応** - i18nの拡張
3. **外部サービス連携** - OAuth、決済など
4. **リアルタイム機能** - Action Cableの活用
5. **管理画面** - より高度な管理機能