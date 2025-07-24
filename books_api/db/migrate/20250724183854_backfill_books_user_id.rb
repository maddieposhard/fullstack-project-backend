class BackfillBooksUserId < ActiveRecord::Migration[8.0]
  def change
    default_user = User.first || User.create!(username: 'placeholder', password: 'password')

    Book.where(user_id: nil).find_each do |book|
      book.update!(user_id: default_user.id)
    end

    change_column_null :books, :user_id, false
  end
end
