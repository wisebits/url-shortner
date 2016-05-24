Dir.glob('./{config,lib,models,services,helpers,controllers}/init.rb').each do |file|
  require file
end

require 'rake/testtask'

namespace :deploy do
  task :config do
    require 'config_env/rake_tasks'
    ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
    Rake::Task['deploy:config_env:heroku'].invoke
  end
end

task :default => [:spec]

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

  desc 'Populate the database with test values'
  task :seed do
    load './db/seeds/users_urls_views.rb'
  end

  desc 'Reset and repopulate database'
  task :reseed => [:reset, :seed]
end

desc 'Run all defined tests'
Rake::TestTask.new(name=:spec) do |t|
	t.pattern = 'specs/*_spec.rb'
end

namespace :key do
	require 'rbnacl/libsodium'
	require 'base64'

	desc 'Create rbnacl key'
	task :generate do
		key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
		puts "KEY: #{Base64.strict_encode64 key}"
	end
end