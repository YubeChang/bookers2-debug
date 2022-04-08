class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(comment_params)
    comment.book_id = @book.id
    comment.save
    @comment_form = BookComment.new
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js #デフォルト値が発火 => bookcomments/create.js.erb
    # redirect_to request.referer
    end
  end

  def destroy
    BookComment.find(params[:id]).destroy
    @book = Book.find(params[:book_id])
    @comment_form = BookComment.new
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js # => book_comments/destroy.js.erb
    end
    # redirect_to request.referer
  end

  private
  def comment_params
    params.require(:book_comment).permit(:comment)
  end

end
