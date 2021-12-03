class PhotosController < ApplicationController
  def index
    # @photos = Photo.all
    publics = User.where({:private => false})
    public_ids = publics.map { |u| u.id }
    @photos = Photo.where({:owner_id => public_ids })
    render({ :template => "photos/all_photos.html.erb"})
  end

  def feed
    # if session[:user_id].nil?
      # redirect_to("/user_sign_in", { :alert => "You have to sign in first."})
    # end
    id = User.where({:username => params.fetch("the_username")}).at(0).id
    requests = FollowRequest.where({:sender_id => id, :status => "accepted"})
    followed_ids = requests.map { |fr| fr.recipient_id }
    @photos = Photo.where({:owner_id => followed_ids })
    render({ :template => "photos/all_photos.html.erb"})
  end

  def create
    user_id = params.fetch("input_owner_id")
    image = params.fetch("input_image")
    caption = params.fetch("input_caption")
    photo = Photo.new
    photo.owner_id = user_id
    photo.image = image
    photo.caption = caption
    photo.save
    redirect_to("/photos/#{photo.id}")
  end

  def show
    if session[:user_id].nil?
      redirect_to("/user_sign_in", { :alert => "You have to sign in first."})
    end
    p_id = params.fetch("the_photo_id")
    @photo = Photo.where({:id => p_id }).at(0)
    render({:template => "photos/details.html.erb"})
  end

  def destroy
    id = params.fetch("the_photo_id")
    photo = Photo.where({ :id => id }).at(0)
    photo.destroy

    redirect_to("/photos")
  end

  def update
    id = params.fetch("the_photo_id")
    photo = Photo.where({ :id => id }).at(0)
    photo.caption = params.fetch("input_caption")
    photo.image = params.fetch("input_image")
    photo.save

    redirect_to("/photos/#{photo.id}")
  end

  def comment
    comment = Comment.new
    comment.body = params.fetch("input_body")
    comment.author_id = params.fetch("input_author_id").to_i
    comment.photo_id = params.fetch("input_photo_id").to_i
    comment.save
  end
end
