class FixTransferableTypeId < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :transferable_id
    add_column :transactions, :transferable_id, :uuid
  end
end
