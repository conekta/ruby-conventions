class AddReferenceToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :reference, index: true, type: :uuid
  end
end
