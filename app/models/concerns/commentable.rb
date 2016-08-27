module Commentable
  extend ActiveSupport::Concern

  included do
    has_many  :comments, as: :commentable, counter_cache: true,  dependent: :destroy
  end

  def commentor_ids
    @commentor_ids ||= comments.pluck(:creator_id).map(&:to_s)
  end
  
  #################### SEED FUNCS

  def comment_by(creator, content = nil)
    count = Comment.count
    content = content || "#{creator.display_name} - Comment - #{count}"
    comment = comments.create(content: content, creator_id: creator.id)
    if comment
      p "Comment created: #{content}"
    else
      p comment.errors.messages.to_sentence
    end
    comment
  end

end







