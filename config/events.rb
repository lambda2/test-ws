WebsocketRails::EventMap.describe do
  namespace :posts do
    subscribe :update, :to => PostsWsController, :with_method => :update
  end
end
