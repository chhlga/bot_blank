class AddSource < ActiveRecord::Migration[7.1]
  def self.up
    add_column :substances_interactions, :source, :string
  end
  def self.down
  end
end
