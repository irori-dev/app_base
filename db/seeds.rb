# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# 開発環境とステージング環境のみ実行
if Rails.env.development? || Rails.env.staging?
  puts "Creating sample admins..."
  
  # 管理者アカウント
  admin = Admin.find_or_create_by!(email: "admin@example.com") do |a|
    a.password = "password123"
  end
  puts "  ✅ Admin created: #{admin.email}"

  # サブ管理者
  sub_admin = Admin.find_or_create_by!(email: "sub.admin@example.com") do |a|
    a.password = "password123"
  end
  puts "  ✅ Sub-admin created: #{sub_admin.email}"

  puts "\nCreating sample users..."
  
  # メインユーザー
  main_user = User::Core.find_or_create_by!(email: "user@example.com") do |u|
    u.password = "password123"
  end
  puts "  ✅ Main user created: #{main_user.email}"

  # テストユーザー（複数）
  5.times do |i|
    user = User::Core.find_or_create_by!(email: "test.user#{i + 1}@example.com") do |u|
      u.password = "password123"
    end
    puts "  ✅ Test user created: #{user.email}"
  end

  puts "\nCreating sample contacts..."
  
  # お問い合わせサンプル
  contacts_data = [
    {
      name: "山田太郎",
      email: "yamada@example.com",
      phone_number: "090-1234-5678",
      text: "サービスについて詳しく知りたいです。資料を送っていただけますか？"
    },
    {
      name: "佐藤花子",
      email: "sato@example.com",
      phone_number: "080-9876-5432",
      text: "アカウントにログインできなくなりました。パスワードリセットの方法を教えてください。"
    },
    {
      name: "鈴木一郎",
      email: "suzuki@example.com",
      phone_number: "070-1111-2222",
      text: "新機能のリクエストがあります。CSVエクスポート機能を追加していただけないでしょうか？"
    }
  ]

  contacts_data.each do |data|
    contact = Contact.find_or_create_by!(email: data[:email]) do |c|
      c.name = data[:name]
      c.phone_number = data[:phone_number]
      c.text = data[:text]
    end
    puts "  ✅ Contact created: #{contact.name} (#{contact.email})"
  end

  puts "\nCreating sample password reset requests..."
  
  # パスワードリセット履歴（テスト用）
  user_with_reset = User::Core.find_by(email: "test.user1@example.com")
  if user_with_reset
    # 期限切れのリセット
    old_reset = user_with_reset.password_resets.create!
    old_reset.update!(created_at: 2.hours.ago)
    puts "  ✅ Expired password reset created for: #{user_with_reset.email}"
    
    # 有効なリセット
    active_reset = user_with_reset.password_resets.create!
    puts "  ✅ Active password reset created for: #{user_with_reset.email}"
  end

  puts "\nCreating sample email change requests..."
  
  # メール変更履歴（テスト用）
  user_with_change = User::Core.find_by(email: "test.user2@example.com")
  if user_with_change
    # 完了済みの変更
    completed_change = user_with_change.email_changes.create!(
      email: "old.email@example.com"
    )
    completed_change.update!(changed_at: 1.day.ago)
    puts "  ✅ Completed email change created for: #{user_with_change.email}"
    
    # 保留中の変更
    pending_change = user_with_change.email_changes.create!(
      email: "new.email@example.com"
    )
    puts "  ✅ Pending email change created for: #{user_with_change.email}"
  end

  puts "\n✨ Seeding completed!"
  puts "\n📝 Login credentials:"
  puts "  Admin: admin@example.com / password123"
  puts "  User: user@example.com / password123"
  
else
  puts "⚠️  Skipping seed data creation in #{Rails.env} environment"
end