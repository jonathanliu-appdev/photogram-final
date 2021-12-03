Rails.application.routes.draw do
  get("/", { :controller => "users", :action => "index" })

  # User routes
  get("/user_sign_up", { :controller => "users", :action => "new_registration_form"} )
  # get("/user_sign_out", { :controller => "users", :action => "toast_cookies"} )
  # get("/user_sign_in", { :controller => "users", :action => "new_session_form"} )
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })
  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })

  # CREATE
  post("/insert_user_record", {:controller => "users", :action => "create" })
  # post("/verify_credentials", {:controller => "users", :action => "authenticate" })
  post("/insert_comment_record", {:controller => "photos", :action => "comment" })

  # READ
  get("/users", {:controller => "users", :action => "index"})
  get("/users/:the_username", {:controller => "users", :action => "show"})

  # UPDATE
  get("/edit_user_profile/", {:controller => "users", :action => "update_form" })
  post("/modify_user/", {:controller => "users", :action => "update" }) # TODO

  # DELETE
  get("/delete_user/:the_user_id", {:controller => "users", :action => "destroy"})

  # FOLLOW
  post("/insert_follow_request", {:controller => "users", :action => "follow" }) # TODO

  # Photo routes

  # LIKE
  post("/insert_like", {:controller => "likes", :action => "insert" })

  # CREATE
  get("/insert_photo_record", { :controller => "photos", :action => "create" })

  # READ
  get("/photos", { :controller => "photos", :action => "index"})
  get("users/:the_username/feed", { :controller => "photos", :action => "feed" })
  get("/photos/:the_photo_id", { :controller => "photos", :action => "show"})

  # UPDATE
  get("/update_photo/:the_photo_id", { :controller => "photos", :action => "update" })

  # DELETE
  get("/delete_photo/:the_photo_id", { :controller => "photos", :action => "destroy"})

  # Comment routes

  # CREATE
  get("/insert_comment_record", { :controller => "comments", :action => "create" })

  # DELETE

  get("/delete_comment/:the_comment_id", { :controller => "comments", :action => "destroy"})
end
