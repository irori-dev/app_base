# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Essential Commands

### Development Setup
```bash
# Install dependencies
bundle install

# Apply database schema (using Ridgepole instead of migrations)
bin/rails ridgepole:apply DATABASE=primary
bin/rails ridgepole:apply DATABASE=cache
bin/rails ridgepole:apply DATABASE=queue

# Start development servers using foreman
foreman start -f Procfile.dev

# Or with Docker
docker compose up
```

### Testing
```bash
# Run all tests
bin/rspec

# Run specific test file
bin/rspec spec/path/to/test_spec.rb

# Run specific test
bin/rspec spec/path/to/test_spec.rb:line_number
```

### Database Schema Management
This project uses Ridgepole instead of Rails migrations. Schema files are in `/db/schema/`.

```bash
# Apply schema changes
bin/rails ridgepole:apply DATABASE=primary

# Dry run (show what would change)
bin/rails ridgepole:dry-run DATABASE=primary

# Export current schema
bin/rails ridgepole:export DATABASE=primary
```

### Code Quality
```bash
# Run RuboCop for code style
bin/rubocop

# Run Brakeman for security analysis
bin/brakeman
```

## Architecture Overview

### Multi-Database Setup
The application uses three separate databases:
- **primary**: Main application data (users, admins, contacts)
- **cache**: Solid Cache storage
- **queue**: Solid Queue job processing

### Authentication System
- **User Authentication**: Located in `app/models/user/core.rb` with password reset (`user/password_reset.rb`) and email change (`user/email_change.rb`) functionality
- **Admin Authentication**: Separate model in `app/models/admin.rb`
- Both use `has_secure_password` with bcrypt

### Component Architecture
- Uses ViewComponent for UI components in `app/components/`
- Components are organized by namespace (admins/, users/, shared components)
- Each component has a Ruby class and HAML template

### Frontend Stack
- **Hotwire**: Turbo + Stimulus for SPA-like interactions
- **Tailwind CSS**: Utility-first CSS framework with hot reload
- **ImportMap**: No node_modules required, JavaScript modules served directly

### Background Jobs
- Uses Solid Queue (database-backed) instead of Redis/Sidekiq
- Job classes in `app/jobs/`
- Monitoring available via Mission Control

### Testing Approach
- RSpec for all tests
- FactoryBot for test data generation
- Capybara for system tests with Selenium
- WebMock for external API mocking
- Tests automatically apply Ridgepole schema before running

### Key Directories
- `/app/controllers/admins/`: Admin-specific controllers with base authentication
- `/app/controllers/users/`: User-specific controllers  
- `/app/views/svgs/`: SVG icons as HAML partials
- `/db/schema/`: Database schema definitions for Ridgepole

### Environment Configuration
- Uses Rails credentials for secrets
- Development uses Letter Opener for email preview
- Exception notifications sent to Slack in production