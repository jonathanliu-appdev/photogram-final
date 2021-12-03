class UsersController < ApplicationController
  def new_registration_form
    render({ :template => "users/signup_form.html.erb" })
  end

  def toast_cookies
    reset_session
    redirect_to("/", { :notice => "See ya later! "})
  end

  def new_session_form
    render({ :template => "users/signin_form.html.erb" })
  end

  def authenticate
    un = params.fetch("query_username")
    pw = params.fetch("query_password")
    user = User.where({ :username => un}).at(0)
    if user == nil
      redirect_to("/user_sign_in", { :alert => "No one by that name 'round these parts!"})
    else
      if user.authenticate(pw)
        session.store(:user_id, user.id)
        redirect_to("/", { :notice => "Welcome back, " + user.username + "!"})
      else
        redirect_to("/user_sign_in", { :alert => "Incorrect password!"})
      end
    end
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end


  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.email = params.fetch("query_email")
    user.username = params.fetch("query_username")
    user.password = params.fetch("query_password")
    user.password_confirmation = params.fetch("query_password_confirmation")
    user.private = !params[:"query_private"].nil?
    user.comments_count = 0
    user.likes_count = 0

    save_status = user.save

    if save_status
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + "!" })
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def follow
    if session[:user_id].nil?
      redirect_to("/user_sign_in", { :alert => "You have to sign in first."})
    end
    if FollowRequest.where({ :recipient_id => params.fetch("query_recipient_id"), :sender_id => session[:user_id]}).count > 0
      redirect_to("/users/", { :alert => "You already have a request."})
    end
    fr = FollowRequest.new
    fr.recipient_id = params.fetch("query_recipient_id")
    fr.sender_id = session[:user_id]
    if User.where({ :id => params.fetch("query_recipient_id") }).at(0).private
      fr.status = "pending"
    else
      fr.status = "accepted"
    end
    fr.save
    redirect_to("/users/#{User.where({ :id => params.fetch("query_recipient_id") }).at(0).username}")
  end

  def update_form
    if session[:user_id].nil?
      redirect_to("/user_sign_in", { :alert => "You have to sign in first."})
    end
    render({ :template => "users/update_form.html.erb" })
  end

  def update
    the_id = session[:user_id]
    user = User.where({ :id => the_id }).at(0)
    user.email = params.fetch("query_email")
    user.username = params.fetch("query_username")
    user.password = params.fetch("query_password")
    user.password_confirmation = params.fetch("query_password_confirmation")

    if user.valid?
      user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      redirect_to("users/update_form.html.erb", { :alert => user.errors.full_messages.to_sentence })
      # render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => user.errors.full_messages.to_sentence })
    end
    
    # redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
