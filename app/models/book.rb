class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search_option, word)
    if    search_option == "perfect_match"               #完全一致
            @books = Book.where("title LIKE ?", "#{word}")
    elsif search_option == "front_match"                 #前方一致
            @books = Book.where("title LIKE ?", "#{word}%")
    elsif search_option == "back_match"                  #後方一致
            @books = Book.where("titlw LIKE ?", "%#{word}")
    else #search_option == "partial_match"               #部分一致
            @books = Book.where("title LIKE ?", "%#{word}%")
    end
  end

end
