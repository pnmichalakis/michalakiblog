require 'bundler'
Bundler.require

require 'sinatra/activerecord/rake'
require 'csv'
require_relative 'connection.rb'
# rake db:create_migration NAME=create_parties_table


namespace :db do
  desc "Create blog_db database"
  task :create_db do
    conn = PG::Connection.open()
    conn.exec('CREATE DATABASE blog_db;')
    conn.close
  end
 	desc "Drop blog_db database"
  task :drop_db do
    conn = PG::Connection.open()
    conn.exec('DROP DATABASE blog_db;')
    conn.close
  end

   desc 'migrate tables for '
   task :migrate do
    conn = PG::Connection.open({dbname:'blog_db'})
    conn.exec("CREATE TABLE attributions (id SERIAL PRIMARY KEY, );")
    conn.close
  end
  desc "seed database with the needed nyc traffic dataset"
  task :load_data do

    require 'CSV'
    conn = PG::Connection.open({dbname: 'traffic_db'})

    CSV.foreach('CCRB__Attribution_of_Complaints_to_Traffic_Control_Division_2005_-_2009.csv', :headers => true) do |row|
      division = row["Division"]
      two_thousand_five = row["2005"]
      two_thousand_six = row["2006"]
      two_thousand_seven = row["2007"]
      two_thousand_eight = row["2008"]
      two_thousand_nine = row["2009"]
      total = row["Total"]

      sql_statement = <<-eos
        INSERT INTO attributions
            (division, two_thousand_five, two_thousand_six, two_thousand_seven, two_thousand_eight, two_thousand_nine, total)
         VALUES
          ($1, $2, $3, $4, $5, $6, $7)
      eos

      conn.exec_params(sql_statement, [division, two_thousand_five, two_thousand_six, two_thousand_seven, two_thousand_eight, two_thousand_nine, total])
    end

    conn.close
  end
end