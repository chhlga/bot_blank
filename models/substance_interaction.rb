require 'active_record'
require 'pry'
ActiveRecord::Base.establish_connection($db_config_admin)

class SubstanceInteraction < ActiveRecord::Base
  self.table_name = 'substances_interactions'
  belongs_to :substance1, class_name: 'Substance'
  belongs_to :substance2, class_name: 'Substance'
  belongs_to :interaction

  def self.find_interaction(sub1, sub2)
    where('weight <> 0').where(substance1: sub1, substance2: sub2).or(where(substance1: sub2, substance2: sub1))
  end

  def sourced_description
    "#{description} (#{source})"
  end
end
