namespace :ridgepole do
  def rails_env
    ENV.fetch('RAILS_ENV', 'development')
  end

  def tables_option
    tables = ENV.fetch('TABLES', '').split(',')
    tables.empty? ? [] : ['--tables', tables.join(',')]
  end

  desc 'Export schema definitions'
  task :export do
    sh 'ridgepole', '--config', 'config/database.yml', '--env', rails_env, '--export', '--split', '--output',
       'db/schema/Schemafile'
  end

  desc 'Show difference between schema definitions and actual schema'
  task :'dry-run' do
    sh 'ridgepole', '--config', 'config/database.yml', '--env', rails_env, '--apply', '--dry-run', '--file',
       'db/schema/Schemafile', *tables_option
  end

  desc 'Apply schema definitions'
  task :apply do
    sh 'ridgepole', '--config', 'config/database.yml', '--env', rails_env, '--apply', '--file', 'db/schema/Schemafile',
       *tables_option
  end
end
