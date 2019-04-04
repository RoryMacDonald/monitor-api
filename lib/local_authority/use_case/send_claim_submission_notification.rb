class LocalAuthority::UseCase::SendClaimSubmissionNotification
  def initialize(email_notification_gateway:)
    @email_notification_gateway = email_notification_gateway
  end

  def execute(email:, url:, by:, name:)
    @email_notification_gateway.send_claim_notification(to: email,
      url: url,
      by: by,
      project_name: name
    )
  end
end
