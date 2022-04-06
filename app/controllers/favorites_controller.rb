class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: @book.id)
    @favorite.save
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
    # redirect_to request.referer
  end

  def destroy
    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: @book.id)
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
     # redirect_to request.referer
  end
end
