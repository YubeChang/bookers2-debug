class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    time = Time.now
    @today =     Book.where(user_id: @user.id,
                         created_at: time.in_time_zone.all_day)
    @yesterday = Book.where(user_id: @user.id,
                         created_at: time.in_time_zone.yesterday.all_day)
    @week =      Book.where(user_id: @user.id,
                         created_at: time.in_time_zone.all_week)
    @prev_week = Book.where(user_id: @user.id,
                         created_at: time.in_time_zone.prev_week.all_week)
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
