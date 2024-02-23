class ChangeUsers < ActiveRecord::Migration[7.1]
  def self.up
    change_column :users, :requests_count, :bigint, default: 0
  end
  def self.down
  end
end
