class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :role
      t.string :name
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end