class SearchesController < ApplicationController

  def search
    @model_name = params[:model_name]
    if @model_name == "User"
    @users = User.looks(params[:search_option], params[:ward])
    else
    @books = Book.looks(params[:search_option], params[:ward])
    end
  end

end