class AddReaction < ActiveRecord::Migration[7.1]
  def self.up
    change_table :substances_interactions do |t|
      t.integer :rating
    end
  end
  def self.down
  end
end
