# frozen_string_literal: true

require 'notifications/client'
class LocalAuthority::Gateway::GovEmailNotificationGateway
  def initialize
    @client = Notifications::Client.new(ENV.fetch('GOV_NOTIFY_API_KEY'), base_url=ENV['GOV_NOTIFY_API_URL'])
  end

  def send_notification(to:, url:, access_token:)
    @client.send_email(
      email_address: to,
      template_id: 'b8fc89b6-79c6-491f-9872-60e110130e4a',
      personalisation: { access_url: "#{url}/?token=#{access_token}" }
    )
  end

  def send_return_notification(to:, url:, by:, project_name:)
    @client.send_email(
      email_address: to,
      template_id: 'f26f9895-97ed-40db-ba50-70fe9f81f97d',
      personalisation: { access_url: url, print_url: "#{url}/print", by: by, project_name: project_name }
    )
  end

  def send_claim_notification(to:, url:, by:, project_name:)
    @client.send_email(
      email_address: to,
      template_id: '2d59a3b6-b2c0-481e-9d2c-7defaee392a8',
      personalisation: { access_url: url, print_url: "#{url}/print", by: by, project_name: project_name }
    )
  end

  def send_project_creation_notification(to:, url:)
    @client.send_email(
      email_address: to,
      template_id: 'd9bd3bd1-5d6c-4bda-8b64-8a21a5879bef',
      personalisation: { access_url: url }
    )
  end
end
