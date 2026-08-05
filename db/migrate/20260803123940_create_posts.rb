class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :post_type, null: false
      t.string :name, null: false
      t.date :date, null: false
      t.string :prefecture
      t.string :genre, null: false
      t.string :repeat_intention, null: false
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
