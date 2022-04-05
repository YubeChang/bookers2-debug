class RelationshipsController < ApplicationController

  #followを作成
  def create
    #ユーザーがフォローするother_userを特定するなんらかのid
    user = User.find_by(params[:id])
    current_user.follow(user)
    redirect_to request.referer
  end

  # followを削除
  def destroy
    user = Relationship.find_by(params[:id]).followed
    current_user.unfollow(user)
    redirect_to request.referer
  end

end
