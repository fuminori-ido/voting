class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string      :code,            null: false
      t.boolean     :admin,           null: false,  default: false
      t.string      :email_address
      t.string      :password_digest

      t.datetime    :deleted_at
      t.timestamps

      t.index       :code
      t.index       :email_address, unique: true
    end
  end
end
