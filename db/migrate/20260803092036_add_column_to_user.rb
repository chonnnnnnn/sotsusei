class AddColumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string, null: false # rubocop:disable Rails/NotNullColumn -- 追加時点で users テーブルが空だったため
  end
end
