class GoalBuddiesInvitationMailer < ApplicationMailer
  def challenge_email(from_user, goal_session, to_email)
    @from_user = from_user
    @goal_session = goal_session
    @to_email = to_email
    subject = "Goal challenge for you: #{@goal_session.goal_detail_name}"
    mail(to: to_email, subject: subject)
  end
end
