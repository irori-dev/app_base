# frozen_string_literal: true

namespace :ridgepole do # rubocop:disable Metrics/BlockLength
  def rails_env
    ENV.fetch('RAILS_ENV', 'development')
  end

  def tables_option
    tables = ENV.fetch('TABLES', '').split(',')
    tables.empty? ? [] : ['--tables', tables.join(',')]
  end

  def database
    ENV.fetch('DATABASE', 'primary')
  end

  desc 'Export schema definitions'
  task :export do
    schemafile = "db/schema/#{database}/Schemafile"

    sh 'ridgepole', '--config', 'config/database.yml', '-s', database, '--env', rails_env, '--export', '--split',
      '--output', schemafile
  end

  desc 'Show difference between schema definitions and actual schema'
  task :'dry-run' do
    schemafile = "db/schema/#{database}/Schemafile"

    sh 'ridgepole', '--config', 'config/database.yml', '-s', database, '--env', rails_env, '--apply', '--dry-run',
      '--file', schemafile, *tables_option
  end

  desc 'Apply schema definitions'
  task :apply do
    schemafile = "db/schema/#{database}/Schemafile"

    sh 'ridgepole', '--config', 'config/database.yml', '-s', database, '--env', rails_env, '--apply', '--file',
      schemafile, *tables_option
  end
end
