RSpec::Matchers.define :make_database_queries do |options = {}|
  match do |block|
    @queries = []

    subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |*, payload|
      @queries << payload[:sql] unless payload[:sql] =~ /^PRAGMA|^SELECT sqlite_version|^BEGIN|^COMMIT|^SAVEPOINT|^RELEASE|^ROLLBACK/
    end

    block.call

    ActiveSupport::Notifications.unsubscribe(subscriber)

    if options[:matching]
      matching_queries = @queries.grep(options[:matching])
      if options[:count]
        matching_queries.size == options[:count]
      else
        matching_queries.any?
      end
    else
      true
    end
  end

  failure_message do
    if options[:matching] && options[:count]
      "expected #{options[:count]} queries matching #{options[:matching].inspect}, but got #{@queries.grep(options[:matching]).size}"
    else
      'expected queries to be made'
    end
  end
end
