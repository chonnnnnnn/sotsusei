class ChangeGenreNullableOnPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :genre, true
  end
end
