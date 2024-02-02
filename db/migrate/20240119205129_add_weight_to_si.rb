class AddWeightToSi < ActiveRecord::Migration[7.1]
  def self.up
    add_column :substances_interactions, :weight, :integer
  end
  def self.down
  end
end
