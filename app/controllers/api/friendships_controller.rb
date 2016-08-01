class Api::FriendshipsController < ApiController
  before_action :authenticate!
  before_action :check_friend_id, only: [:request_friend, :accept_friend, :reject_friend]

  def incomming
    success(data: current_user.pending_invited_by)
  end

  def outgoing
    success(data: current_user.pending_invited)
  end

  def request_friend
    if current_user.invite(@friend)
      success(data: { message: "Friend request sent successfully."})
    else
      error(message: "Friend request sent.")
    end
  end

  def accept_friend
    if current_user.approve(@friend)
      success(data: { message: "Friend request accepted successfully."})
    else
      error(message: "Friend request accepted fail.")
    end
  end

  def reject_friend
    friendship = current_user.friendship_with(@friend)
    if friendship.present? && friendship.destroy
      success(data: { message: "Friend request reject successfully."})
    else
      error(message: "Friend request reject fail.")
    end
  end

  def destroy
    if @friendship.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @friendship.errors.full_messages.to_sentence)
    end
  end

  private

  def check_friend_id
    @friend ||= User.find_by_id(params[:friend_id])
    error(message: "Friend for your request does not exists.") unless @friend.present?
  end

end
