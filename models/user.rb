require 'pry'
ActiveRecord::Base.establish_connection($db_config_admin)

class User < ActiveRecord::Base
  self.table_name = self.name.pluralize.downcase
end
