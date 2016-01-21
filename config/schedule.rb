# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, { error: 'error.log', standard: 'cron.log' }
#
# require 'database_backup.rb'

every 3.hours do
  puts 'in every minutes backup'
  # command "/usr/bin/some_great_command"
  runner "Setting.take_database_backup"
  # rake "some:great:rake:task"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
