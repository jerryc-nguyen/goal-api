class Amistad::Friendships::UserFriendship < ActiveRecord::Base
  
  private

  after_commit on: [:create] do
    friendship = Friendship.new(self.attributes)
    #FriendshipBuilder.new(friendship).after_commit_on_create
  end

  after_commit on: [:update] do
    unless blocker_id
      friendship = Friendship.new(self.attributes)
      #FriendshipBuilder.new(friendship).after_commit_on_accept_friend_request
    end
  end

  after_commit on: [:destroy] do
    p "Destroy UserFriendship!"
    p self
  end

end
