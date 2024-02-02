require 'active_record'
require 'pry'
ActiveRecord::Base.establish_connection($db_config_admin)

class Interaction < ActiveRecord::Base
  self.table_name = self.name.pluralize.downcase
  has_many :substance_interractions
end
