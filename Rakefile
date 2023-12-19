require "active_record"

namespace :db do
  db_config       = YAML::load(File.open('config/database.yml'))[ENV['enviroment'] || 'production']
  db_config_admin = db_config.merge({'schema_search_path' => 'public'})

  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config_admin.merge({'database' => 'postgres'}))
    ActiveRecord::Base.connection.create_database(db_config["database"])
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)

    migration_context = if ActiveRecord.version >= Gem::Version.new('6.0')
                          ActiveRecord::MigrationContext.new("db/migrate/", ActiveRecord::SchemaMigration)
                        else
                          ActiveRecord::MigrationContext.new("db/migrate/")
                        end

    migration_context.migrate

    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(db_config_admin.merge({'database' => 'postgres'}))
    ActiveRecord::Base.connection.drop_database(db_config["database"])
    puts "Database deleted."
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = "db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[7.1]
  def self.up
  end
  def self.down
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end

  desc "Generate model"
  task :model do
    name = ARGV[1] || raise("Specify name: rake g:model your_model")
    path = File.expand_path("../models/#{name}.rb", __FILE__)
    model_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
require 'base'
require 'pry'
ActiveRecord::Base.establish_connection($db_config_admin)

class #{model_class} < ActiveRecord::Base
  self.table_name = self.name.pluralize.downcase
end
      EOF
    end
    puts 'Model created'

    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    Rake::Task["g:migration"].invoke

    abort
  end
end

