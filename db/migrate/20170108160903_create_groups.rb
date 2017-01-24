class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :rating_filter
      t.string :keyword
      t.string :location
      t.string :access_token
      t.integer :radius
      t.boolean :cost_filter1
      t.boolean :cost_filter2
      t.boolean :cost_filter3
      t.boolean :cost_filter4
      t.string 'users', array: true
      t.timestamps
    end
    add_index :groups, :users, using: 'gin'
  end
end
