class Intarraction < ActiveRecord::Migration[7.1]
  def self.up
    create_table :interactions do |t|
      t.string :description
      t.integer :number
    end
  end
  def self.down
  end
end
