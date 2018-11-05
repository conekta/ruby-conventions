class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.decimal :balance, precision: 10, scale: 2
      t.integer :account_type
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
