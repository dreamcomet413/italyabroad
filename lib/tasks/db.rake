$KCODE = 'u'
require 'jcode'

task :dump => :environment do
  FileUtils.mkdir_p "#{RAILS_ROOT}/db/dump/"
  tables = ActiveRecord::Base.connection.tables
  tables.each do |table_name|
    clazz = table_name.classify.constantize rescue nil
    if clazz
      query = if table_name == 'search_queries'
        table_name = 'searches'
        "select lower(query) as query, count(1) as popularity from search_queries where created_at > '#{6.months.ago.to_s(:db)}' group by lower(query)"
      else
        "select * from #{table_name}"
      end
      all = clazz.connection.select_all(query)
      all.each do |row|
        row.values.each { |value| value = value.toutf8 if value }
      end
      puts "#{table_name}: #{all.size}"
      # File.open("#{RAILS_ROOT}/db/dump/#{table_name}.json", 'w') do |file|
      #   # all = clazz.find(:all).collect { |instance| instance.attributes }
      #   file.write all.to_json
      # end
      # File.open("#{RAILS_ROOT}/db/dump/#{table_name}.yml", 'w') do |file|
      #   # all = clazz.find(:all).collect { |instance| instance.attributes }
      #   YAML.dump all, file
      # end
      File.open("#{RAILS_ROOT}/db/dump/#{table_name}.xml", 'w') do |file|
        file.write all.to_xml
      end
    end
  end
end
