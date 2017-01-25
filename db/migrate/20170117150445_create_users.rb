class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :group_id
      t.string :username
      t.integer :preferences, array: true, default: []
      t.string :restaurants

      t.timestamps
    end
  end
end
