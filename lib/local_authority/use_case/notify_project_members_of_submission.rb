class LocalAuthority::UseCase::NotifyProjectMembers
  def initialize(send_return_submission_notification:, send_claim_submission_notification:, get_project_users:, find_project:)
    @get_project_users = get_project_users
    @send_return_submission_notification = send_return_submission_notification
    @send_claim_submission_notification = send_claim_submission_notification
    @find_project = find_project
  end

  def execute(project_id:, url:, by:, type: :return)
    project_name = @find_project.execute(id: project_id)[:name]
    emails = @get_project_users.execute(project_id: project_id)[:users]
    emails.each do |email|
      @send_return_submission_notification.execute(email: email, url: url, by: by, name: project_name) if type == :return
      @send_claim_submission_notification.execute(email: email, url: url, by: by, name: project_name) if type == :claim

    end
  end
end
