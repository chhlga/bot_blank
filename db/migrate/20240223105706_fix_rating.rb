class FixRating < ActiveRecord::Migration[7.1]
  def self.up
    change_column :substances_interactions, :rating, :bigint, default: 0
  end
  def self.down
  end
end
