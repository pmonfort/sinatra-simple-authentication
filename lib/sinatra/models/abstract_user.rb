current_path = File.expand_path("..", __FILE__)
if Object.const_defined?("DataMapper")
  require File.join(current_path, 'datamapper/user')
elsif Object.const_defined?("ActiveRecord")
  require File.join(current_path, 'active_record/user')
end
