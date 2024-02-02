require 'active_record'
require 'pry'
ActiveRecord::Base.establish_connection($db_config_admin)

class Substance < ActiveRecord::Base
  self.table_name = self.name.pluralize.downcase
  has_many :substance_interactions, as: :substance1
  has_many :substance_interactions, as: :substance2
end
