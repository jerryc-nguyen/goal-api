class Api::ChatsController < ApiController
  before_action :authenticate!
  before_action :find_chat, only: [ :update, :destroy ]

  def index
    chats = Chat.messages_of(current_user).page(params[:page] || 1)
    success(data: chats)
  end

  def chatting
    chats = if params[:goal_id].to_i > 0
      Chat.buddies_chat_for(params[:goal_id]).page(params[:page] || 1)
    else
      Chat.friend_chat_for(current_user.id, params[:receiver_id]).page(params[:page] || 1)
    end
    success(data: chats)
  end

  def create
    chat = current_user.sent_chats.create(chat_params)
    if chat.valid?
      success(data: chat)
    else
      error(message: chat.errors.full_messages.to_sentence)
    end
  end

  def update
    if @chat.update(chat_params)
      success(data: @chat)
    else
      error(message: @chat.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @chat.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @chat.errors.full_messages.to_sentence)
    end
  end

  private

  def find_chat
    @chat ||= Chat.find(params[:id])
  end

  def chat_params
    @chat_params ||= params.require(:chat).permit(*Settings.params_permitted.chat)
  end

end
