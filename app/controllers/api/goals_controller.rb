class Api::GoalsController < ApiController
  before_action :authenticate!
  before_action :find_goal, only: [ :show, :update, :destroy, :like_toggle, :comments, :comment]
  before_action :validate_goal_owner, only: [ :update, :destroy ]

  def index
    success(data: Goal.joined_by(current_user))
  end

  def show
    success(data: @goal, serializer: Api::GoalDetailSerializer)
  end

  def create
    Goal.transaction do
      if (goal = current_user.goals.create(goal_params)).valid?
        if (goal_session = goal.add_participant_for(current_user)).valid?
          success(data: goal_session)
        else
          error(message: goal_session.errors.full_messages.to_sentence)
          raise ActiveRecord::Rollback
        end
      else
        error(message: goal.errors.full_messages.to_sentence)
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    if @goal.update(goal_params)
      success(data: @goal)
    else
      error(message: @goal.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @goal.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @goal.errors.full_messages.to_sentence)
    end
  end
  
  def like_toggle
    like = @goal.likes.with_deleted.find_by(creator_id: current_user.id)
    if like.present?
      if like.deleted?
        like.restore
      else
        like.destroy
      end
    else
      @goal.likes.create(creator_id: current_user.id)
      notifier_service.notify_like
    end
    success(data: @goal.reload)
  end

  def comments
    success(data: @goal.comments.order(id: :desc).page(params[:page] || 1))
  end

  def comment
    comment = @goal.comments.new(comment_params)
    if comment.save
      notifier_service.notify_comment
      success(data: comment)
    else
      error(message: comment.errors.full_messages.to_sentence)
    end
  end

  private

  def notifier_service
    @notifier_service ||= PushServices::GoalNotifier.new(current_user, @goal)
  end

  def comment_params
    @comment_params ||= params.require(:comment)
      .permit(*Settings.params_permitted.comment)
      .merge(creator_id: current_user.id)
  end

  def validate_goal_owner
    error(message: "Only goal creator can do this.") if current_user.id != @goal.creator_id
  end

  def find_goal
    @goal ||= Goal.find(params[:id])
  end

  def goal_params
    @goal_params ||= params.require(:goal).permit(*Settings.params_permitted.goal).tap do |permitted_params| 
      permitted_params[:repeat_every] = params[:goal][:repeat_every] if params[:goal][:repeat_every].present?
    end
  end

end
