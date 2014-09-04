class PostsWsController < WebsocketRails::BaseController
  def update
    p message
    raise "lol"

    #WebsocketRails["chat"].trigger 'new', ["avatar.png", "1 sec", user.email, message[:text]]
  end
end
