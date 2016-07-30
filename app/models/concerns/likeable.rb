module Likeable
  extend ActiveSupport::Concern

  included do
    has_many  :likes, as: :likeable,  dependent: :destroy
  end

  def liker_ids
    likes.pluck(:creator_id)
  end

  def like_by creator
    like = likes.create(creator_id: creator.id)
    if like
      p "Like created by #{creator.display_name}"
    else
      p like.errors.messages.to_sentence
    end
  end

end
