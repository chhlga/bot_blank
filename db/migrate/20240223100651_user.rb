class User < ActiveRecord::Migration[7.1]
  def self.up
    create_table :users do |t|
      t.string :uuid
      t.bigint :chat_id
      t.bigint :requests_count
    end
  end
  def self.down
    drop_table :users
  end
end
