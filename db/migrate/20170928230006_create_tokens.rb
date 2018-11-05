class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens, id: :uuid do |t|
      t.string :token
      t.integer :type
      t.references :user, foreign_key: true, type: :uuid
      t.datetime :expires_at

      t.timestamps
    end
  end
end
