class LikesController < ApplicationController
  def insert
    if session[:user_id].nil?
      redirect_to("/user_sign_in", { :alert => "You have to sign in first."})
    end
    # increment liker count
    user = User.where({ :id => session[:user_id] }).at(0)
    if user.likes_count.nil?
      user.likes_count = 1
    else
      user.likes_count += 1
    end
    like = Like.new
    like.fan_id = session[:user_id]
    like.photo_id = params.fetch("query_photo_id")

    like.save

    redirect_to("/photos/#{like.photo_id}", { :notice => "Like created successfully."})
  end

end
