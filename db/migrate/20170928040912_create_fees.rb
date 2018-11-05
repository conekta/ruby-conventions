class CreateFees < ActiveRecord::Migration[5.1]
  def change
    create_table :fees, id: :uuid do |t|
      t.string :description
      t.decimal :lower_range, precision: 10, scale: 2
      t.decimal :upper_range, precision: 10, scale: 2
      t.decimal :flat_fee, precision: 10, scale: 2
      t.decimal :variable_fee, precision: 5, scale: 2

      t.timestamps
    end
  end
end
