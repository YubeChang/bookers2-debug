class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,         dependent: :destroy
  has_many :favorites,     dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :active_relationships,  class_name: "Relationship",
                                  foreign_key: "follower_id",
                                    dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                    dependent: :destroy

  has_many :following,                through: :active_relationships,
                                       source: :followed
  has_many :followers,                through: :passive_relationships,
                                       source: :follower


  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  #動かなくなってて草
  # def get_profile_image(width,height)
  #   (profile_image.attached?) ? profile_image.variant(resize_to_limit: [width, height]).processed : no_image.jpg.variant(resize_to_limit: [width, height]).processed
  # end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end

  #_header検索フォームのデータ受け取り処理
  def self.looks(search_option, word)
    if    search_option == "perfect_match"               #完全一致
            @users = User.where("name LIKE ?", "#{word}")
    elsif search_option == "front_match"                 #前方一致
            @users = User.where("name LIKE ?", "#{word}%")
    elsif search_option == "back_match"                  #後方一致
            @users = User.where("name LIKE ?", "%#{word}")
    else #search_option == "partial_match"               #部分一致
            @users = User.where("name LIKE ?", "%#{word}%")
    end
  end

end
