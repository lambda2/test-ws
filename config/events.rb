WebsocketRails::EventMap.describe do
  namespace :posts do
    subscribe :hello, :to => PostsWsController, :with_method => :hello
    subscribe :action, :to => PostsWsController, :with_method => :action
  end
end
