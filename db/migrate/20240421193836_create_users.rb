class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :timezone, null: false, default: "Eastern Time (US & Canada)"

      t.timestamps

      t.index :email, unique: true
    end
  end
end
