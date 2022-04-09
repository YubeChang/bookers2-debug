class SearchesController < ApplicationController

  def search
    @model_name = params[:model_name]
    if @model_name == "User"
    @users = User.looks(params[:search_option], params[:ward])
    else　# @model_name == "Book"
    @books = Book.looks(params[:search_option], params[:ward])
    end
  end

  def search_post_day
    # time = Time.find(params[:post_day]).all_day
    date = DateTime.parse(params[:post_day]).all_day
    @books = Book.where(user_id: params[:user_id], created_at: date)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

end