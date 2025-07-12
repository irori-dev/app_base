# frozen_string_literal: true

if defined?(Bullet)
  Bullet.enable = true

  # アラートをブラウザに表示
  Bullet.alert = true

  # ブラウザのコンソールにログ出力
  Bullet.console = true

  # Railsログに出力
  Bullet.rails_logger = true

  # Bulletのログファイルに出力
  Bullet.bullet_logger = true

  # 未使用のeager loadingを検出
  Bullet.unused_eager_loading_enable = true

  # N+1クエリを検出
  Bullet.n_plus_one_query_enable = true

  # カウンターキャッシュの提案
  Bullet.counter_cache_enable = true

  # アプリケーション起動時のチェックをスキップ
  Bullet.skip_html_injection = false

  # 除外設定（必要に応じて追加）
  # Bullet.add_safelist type: :n_plus_one_query, class_name: "User", association: :posts
  # Bullet.add_safelist type: :unused_eager_loading, class_name: "User", association: :posts

  # development環境のみで有効化
  Bullet.enable = Rails.env.development?
end