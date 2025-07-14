# インフラストラクチャ運用ガイド

## 新しいアプリケーションの追加手順

### 1. 必要なSecrets設定
GitHub Secretsに以下の値を設定してください：

```
AWS_ROLE_ARN=arn:aws:iam::ACCOUNT_ID:role/OIDC_ROLE_NAME
AWS_REGION=ap-northeast-1
AWS_ACCOUNT_ID=435917083888
DATABASE_URL=postgresql://user:pass@host:5432/db
CACHE_DATABASE_URL=redis://host:6379/0
QUEUE_DATABASE_URL=redis://host:6379/1
RAILS_MASTER_KEY=your_rails_master_key
SLACK_BOT_TOKEN=xoxb-... (optional)
SLACK_CHANNEL_ID=C1234567890 (optional)
```

### 2. インフラ初期構築（手動実行）
1. GitHub ActionsのActions tabを開く
2. "Setup Infrastructure (Manual Only)"ワークフローを選択
3. "Run workflow"をクリック
4. 以下のパラメータを入力：
   - `app_name`: アプリケーション名（例：user-management）
   - `environment`: 環境（prod または staging）
   - `hostname`: ホスト名(subdomain.workshop-app.net)（例：user-management.workshop-app.net）

### 3. 自動作成されるリソース
- **CloudFormation Stack**: `{app_name}-{environment}-infra`
- **ECR Repository**: `workshop-app/{environment}/{app_name}`
- **SSM Parameters**: `/{app_name}/{environment}/*`
- **IAM Roles**: ECS実行ロール、タスクロール
- **ALB Target Group**: アプリケーション用
- **ALB Listener Rule**: ホスト名ベースルーティング
- **CloudWatch Log Group**: `/ecs/{app_name}`

### 4. 継続的デプロイ
インフラ構築後、mainブランチへのpushで自動デプロイが実行されます：

1. テストの実行
2. Dockerイメージのビルド・プッシュ
3. ECSサービスの更新
4. サービス安定性の確認
5. Slack通知（設定済みの場合）

## ファイル構成

```
.github/workflows/
├── setup-infrastructure.yml  # インフラ初期構築（手動実行のみ）
└── deploy.yml                # アプリケーション継続的デプロイ

infra/apps/app-base/
├── infra-base.yaml           # インフラリソース（ALB、IAM、Logs）
└── app-deploy.yaml           # アプリケーションデプロイ（ECS Task/Service）
```

## 運用上の注意点

### ALBリスナールール優先度
- 自動で次の利用可能な優先度が割り当てられます
- 複数アプリケーションが同じALBを共有する場合の競合を回避

### Secrets管理
- GitHub SecretsからSSM Parameter Storeに自動複製
- アプリケーションはSSMから環境変数を取得
- セキュアな値は暗号化済みで保存

### ECRリポジトリ命名規則
```
workshop-app/{environment}/{app_name}
例：workshop-app/prod/user-management
```

### CloudFormationスタック名規則
```
{app_name}-{environment}-infra    # インフラスタック
{app_name}-app                    # アプリケーションスタック
```

## トラブルシューティング

### デプロイが失敗する場合
1. インフラスタックの存在確認：
   ```bash
   aws cloudformation describe-stacks --stack-name your-app-prod-infra
   ```

2. ECR_REPOSITORY secretの確認：
   GitHub Settings > Secrets and variables > Actions

3. SSMパラメータの確認：
   ```bash
   aws ssm get-parameters-by-path --path "/your-app/prod/"
   ```

### 新しいアプリケーションでデプロイがスキップされる場合
setup-infrastructure.ymlワークフローを先に実行してください。

### ALBリスナールール優先度の競合
手動で優先度を指定する場合は、CloudFormationテンプレートの`ListenerRulePriority`パラメータを更新してください。

## セキュリティ考慮事項

1. **OIDC認証**: GitHub ActionsはOIDCでAWSにアクセス（長期クレデンシャル不要）
2. **最小権限の原則**: IAMロールは必要最小限の権限のみ
3. **Secrets暗号化**: SSM Parameter StoreのSecureStringタイプを使用
4. **ネットワーク分離**: Fargateタスクはプライベートサブネットで実行

## 料金最適化

1. **Fargate Spot**: 本番以外での利用を検討
2. **CloudWatch Logs保持期間**: 7日間（調整可能）
3. **ECS Auto Scaling**: 負荷に応じたスケールアウト・イン
4. **ALB共有**: 複数アプリケーションで同じALBを共用

## 監視・ログ

- **CloudWatch Logs**: `/ecs/{app_name}`にアプリケーションログ
- **ALB Access Logs**: リクエストレベルの監視
- **ECS Service Metrics**: CPU、メモリ使用率の監視
- **Slack通知**: デプロイ成功・失敗の自動通知
