class Fix < ActiveRecord::Migration[7.1]
  def self.up
    change_table :substances_interactions do |t|
      t.string :substance1_type
      t.string :substance2_type
    end
  end
  def self.down
  end
end
