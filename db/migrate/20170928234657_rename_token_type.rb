class RenameTokenType < ActiveRecord::Migration[5.1]
  def change
    rename_column :tokens, :type, :token_type
  end
end
