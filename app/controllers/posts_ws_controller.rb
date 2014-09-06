require 'securerandom'

class PostsWsController < WebsocketRails::BaseController
#  def initialize_session
#    controller_store[:collaborative_content] = CollaborativeContent.new
#  end

  def hello
    p message
    controller_store[:collaborative_content] ||= CollaborativeContent.new
    send_all
  end

  def action
    p message
    puts "Version: #{message[:v]}".yellow
    version = message[:v]
    method = {'i' => :insert, 'd' => :delete}[message[:t]]

    if method
      if controller_store[:collaborative_content].do_modif(method, message[:p], message[:c], version) == :conflict
        send_all
      else
        send_feedback
      end
    elsif message[:t]
      controller_store[:collaborative_content].update_cursor message[:uid], "login_#{message[:uid]}", message[:p]
      send_feedback
    end

#    p controller_store[:collaborative_content].versions
#    p controller_store[:collaborative_content].cursors
    p "New content: #{controller_store[:collaborative_content].content} : Version : #{controller_store[:collaborative_content].versions.count}"
  end

  private

  def send_all
    WebsocketRails[:posts].trigger :all, {uid: message[:uid] || SecureRandom.hex}.merge(controller_store[:collaborative_content].dump_state)
  end

  def send_feedback
    WebsocketRails[:posts].trigger :feedback, {:success => true}.merge(message)
  end
end
