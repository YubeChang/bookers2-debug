class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @time = Time.now
    @today =     Book.where(user_id: @user.id,
                         created_at: @time.in_time_zone.all_day)
  # これをリファクタリングしたい
    # @day1 =      Book.where(user_id: @user.id,
    #                     created_at: @time.in_time_zone.ago(1.days).all_day)
    # @day2 =      Book.where(user_id: @user.id,
    #                     created_at: @time.in_time_zone.ago(2.days).all_day)
    # @day3 =      Book.where(user_id: @user.id,
    #                     created_at: @time.in_time_zone.ago(3.days).all_day)
    # @day4 =      Book.where(user_id: @user.id,
    #                     created_at: @time.in_time_zone.ago(4.days).all_day)
    # @day5 =      Book.where(user_id: @user.id,
    #                     created_at: @time.in_time_zone.ago(5.days).all_day)
    # @day6 =      Book.where(user_id: @user.id,
    #                     created_at: @time.in_time_zone.ago(6.days).all_day)
  # 絶対間違ってる、これ過去の履歴作る時全部手書きすることになるやんけ。creaated_atでwhereする方法ないかな

  #リファクタリング案１<動的メソッド作成>
  #スッキリはしたけどこれだと「何日分のデータが欲しい」って時に書き直さないと検索できない
    6.times do |i|
      instance_variable_set("@day"+(i + 1).to_s,
                            Book.where(user_id: @user.id,
                                    created_at: @time.in_time_zone.ago((i + 1).days).all_day)
                            )
    end

  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def followers
    @users = User.find(params[:id]).followers
  end

  def following
    @users = User.find(params[:id]).following
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
