class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :transaction_type
      t.references :transferable, polymorphic: true
      t.references :user, foreign_key: true, type: :uuid
      t.decimal :user_balance, precision: 10, scale: 2
      t.decimal :transferable_balance, precision: 10, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
