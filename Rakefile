require './app'

namespace :db do
	require 'sequel'
	Sequel.extension :migration

	desc 'Run migrations'
	task :migrate do
		puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
		puts 'Migrating to latest'
		Sequel::Migrator.run(DB, 'db/migrations')
	end

	desc 'Perform migration reset (full rollback and migration)'
	task :reset do
		Sequel::Migrator.run(DB, 'db/migrations', target: 0)
		Sequel::Migrator.run(DB, 'db/migrations')
	end
end

