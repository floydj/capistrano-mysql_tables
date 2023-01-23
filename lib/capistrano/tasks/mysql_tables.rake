require "yaml"

def local_db_attributes
  db_file = YAML.load_file("config/database.yml")
  DatabaseAttributes.new(database: db_file["development"]["database"],
                         username: db_file["development"]["username"],
                         password: db_file["development"]["password"],
                         host: db_file["development"]["host"],
                         port: db_file["development"]["port"])
end

def remote_db_attributes
  database = capture :ruby, %{-e \"require('yaml'); puts YAML.load_file('config/database.yml')['#{fetch(:rails_env)}']['database']\"}
  username = capture :ruby, %{-e \"require('yaml'); puts YAML.load_file('config/database.yml')['#{fetch(:rails_env)}']['username']\"}
  DatabaseAttributes.new(database: database,
                         username: username)
end

namespace :db do
  desc "Push tables to server"
  task :push_tables, :tables do |t, args|
    set :sql_file, "tmp/from_local.sql"

    if args[:tables]
      set :table_names, args[:tables]
    else
      ask(:table_names, "the table names you want to push")
    end

    run_locally do
      db = local_db_attributes
      puts %x[mysqldump -u#{db.username} -p#{db.password} -h #{db.host} -P #{db.port} #{db.database} #{fetch(:table_names)} > #{fetch(:sql_file)}]
    end

    on roles(:db) do
      within shared_path do
        db = remote_db_attributes
        set :remote_database, db.database
        set :remote_username, db.username

        upload! fetch(:sql_file), "./from_local.sql"
        execute "mysql -u #{fetch(:remote_username)} #{fetch(:remote_database)} < #{shared_path}/from_local.sql"
      end
    end
  end

  desc "Pull tables from server"
  task :pull_tables, :tables do |t, args|
    set :sql_file, "#{shared_path}/from_remote.sql"

    if args[:tables]
      set :table_names, args[:tables]
    else
      ask(:table_names, "the table names you want to pull")
    end

    on roles(:db) do
      within shared_path do
        db = remote_db_attributes
        set :remote_database, db.database
        set :remote_username, db.username

        execute("mysqldump -u#{fetch(:remote_username)} #{fetch(:remote_database)} #{fetch(:table_names)} > #{fetch(:sql_file)}")
        download! fetch(:sql_file), "tmp/from_remote.sql"
      end
    end

    run_locally do
      db = local_db_attributes
      puts %x[mysql -u #{db.username} -p#{db.password} -h #{db.host} -P #{db.port} #{db.database} < tmp/from_remote.sql]
    end
  end
end

