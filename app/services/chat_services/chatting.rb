module ChatServices
  class Chatting

    def initialize(current_user, chat)
      @current_user = current_user
      @chat = chat
    end

    def process
      if @chat.receiver.present?
        direct_chat
      else @chat.goal.present?
        group_chat
      end
    end

    def self.send_message(to_channel: nil, message: { event_type: "test_message", data: "Hello from Goal API Backend" })
      ChatServices::PubnubClient.instance.publish(to_channel, message)
    end

    private 

    def direct_chat
      return if @current_user.id == @chat.receiver.id
      p "Pushing direct message to: #{@chat.receiver.display_name}, #{ @chat.receiver.realtime_channel }"
      ChatServices::Chatting.send_message(
        to_channel: @chat.receiver.realtime_channel,
        message: {
          event_type: "chatting_direct",
          data: @chat.serialize
        }
      )
    end

    def group_chat
      User.participants_of(@chat.goal).each do |user|
        next if user.id == @current_user.id

        p "Pushing group_chat to: #{user.display_name}, #{ user.realtime_channel }"
        ChatServices::Chatting.send_message(
          to_channel: user.realtime_channel,
          message: {
            event_type: "chatting_group",
            data: @chat.serialize
          }
        )
      end
    end

  end
end
