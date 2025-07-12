class Admins::ErrorsController < Admins::BaseController

  # GET /admins/errors/trigger
  # 意図的にエラーを発生させるエンドポイント（アラート通知のテスト用）
  # 本番環境でも利用可能（管理者権限が必要）
  def trigger # rubocop:disable Metrics/CyclomaticComplexity
    error_type = params[:type] || 'standard'

    case error_type
    when 'standard'
      raise StandardError, 'This is a test error for alert notification testing'
    when 'runtime'
      raise 'This is a test runtime error for alert notification testing'
    when 'argument'
      raise ArgumentError, 'This is a test argument error for alert notification testing'
    when 'not_found'
      raise ActiveRecord::RecordNotFound, 'This is a test record not found error'
    when 'timeout'
      raise Timeout::Error, 'This is a test timeout error'
    when 'database'
      # データベース接続エラーをシミュレート
      ActiveRecord::Base.connection.execute('SELECT * FROM non_existent_table')
    when 'zero_division'
      1 / 0
    when 'nil'
      nil.undefined_method_call
    else
      raise "Unknown test error type: #{error_type}"
    end
  end

end
