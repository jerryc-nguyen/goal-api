class Api::CommentsController < ApiController
  before_action :authenticate!
  before_action :find_comment, only: [ :update, :destroy, :like_toggle ]

  def update
    if @comment.update(comments_params)
      success(data: @comment)
    else
      error(message: @comment.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @comment.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @comment.errors.full_messages.to_sentence)
    end
  end

  def like_toggle
    like = @comment.likes.with_deleted.find_by(creator_id: current_user.id)
    if like.present?
      if like.deleted?
        like.restore
      else
        like.destroy
      end
    else
      @comment.likes.create(creator_id: current_user.id)
      notifier_service.notify_like_comment_for(@comment)
    end
    success(data: @comment.reload)
  end

  private
  
  def notifier_service
    @notifier_service ||= PushServices::GoalNotifier.new(current_user, @goal)
  end

  def find_comment
    @comment ||= current_user.comments.find(params[:id])
  end

  def comments_params
    @comments_params ||= params.require(:comment).permit(*Settings.params_permitted.comment)
  end

end
