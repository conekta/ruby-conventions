class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards, id: :uuid do |t|
      t.string :last_4
      t.string :bank_token
      t.integer :card_type
      t.string :issuer
      t.integer :status
      t.date :expiration
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
