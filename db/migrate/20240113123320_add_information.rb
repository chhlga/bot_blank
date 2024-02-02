class AddInformation < ActiveRecord::Migration[7.1]
  def self.up
    change_table :substances do |t|
      t.text :information
    end
  end
  def self.down
  end
end
