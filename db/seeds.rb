require 'active_record/fixtures'
  
def yaml_to_database(fixture, path)
  ActiveRecord::Base.establish_connection(Rails.env)
  tables = Dir.new(path).entries.select{|e| e =~ /(.+)?\.yml/}.collect{|c| c.split('.').first}
  Fixtures.create_fixtures(path, tables)
end

# load setup data from seeds
fixture = "data"
directory = "#{Rails.root}/db/#{fixture}"

puts "loading fixtures from #{directory}"
yaml_to_database(fixture, directory)
puts "done."
