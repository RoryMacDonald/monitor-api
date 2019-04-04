# frozen_string_literal: true
require_relative '../../../simulator/notification'

describe LocalAuthority::Gateway::GovEmailNotificationGateway do
  let(:notification_url) { 'http://meow.cat/' }

  let(:simulator) { Simulator::Notification.new(self, notification_url) }

  let(:send_mail_spy) do
    spy(send_email: {})
  end

  let(:notifications_client_spy) do
    spy(new: send_mail_spy, meow: 'cat')
  end

  before do
    ENV['GOV_NOTIFY_API_KEY'] = 'cafe-cafecafe-cafe-cafe-cafe-cafecafecafe-cafecafe-cafe-cafe-cafe-cafecafecafe'
  end

  context 'sending a login token' do
    context 'example 1' do
      let(:notification_request) do
        stub_request(
          :post,
          'https://meow.com/v2/notifications/email'
        ).to_return(status: 200, body: '{}')
      end

      before do
        notification_request
        ENV['GOV_NOTIFY_API_URL'] = 'https://meow.com'
        simulator.send_notification(to: 'cat@cathouse.com')
        described_class.new.send_notification(to: 'cat@cathouse.com', url: 'http://cats.com', access_token: 'CatAccess')
      end

      context 'given email address and url' do
        it 'will run send_email with address and url within personalisation hash' do
          expect(notification_request.with do |req|
            request_body = JSON.parse(req.body)
            expect(request_body['email_address']).to eq('cat@cathouse.com')
            expect(request_body['personalisation']['access_url']).to eq('http://cats.com/?token=CatAccess')
          end).to have_been_made
        end
      end
    end

    context 'example 2' do
      let(:notification_request) do
        stub_request(
          :post,
          'https://dog.woof/v2/notifications/email'
        ).to_return(status: 200, body: '{}')
      end

      let(:notification_url) { 'http://dog.woof/' }

      before do
        notification_request
        ENV['GOV_NOTIFY_API_URL'] = 'https://dog.woof'
        simulator.send_notification(to: 'dog@doghouse.com')
        described_class.new.send_notification(to: 'dog@doghouse.com', url: 'http://dogs.com', access_token: 'DogAccess')
      end

      context 'given email address and url' do
        it 'will run send_email with address and url within personalisation hash' do
          expect(notification_request.with do |req|
            request_body = JSON.parse(req.body)
            expect(request_body['email_address']).to eq('dog@doghouse.com')
            expect(request_body['personalisation']['access_url']).to eq('http://dogs.com/?token=DogAccess')
          end).to have_been_made
        end
      end
    end
  end

  context 'sending a return submission notification' do
    context 'example 1' do
      let(:notification_url) { 'https://dog.woof/' }
      before do
        ENV['GOV_NOTIFY_API_URL'] = 'https://dog.woof'
        simulator.send_notification(to: 'dog@doghouse.com')
        described_class.new.send_return_notification(to: 'dog@doghouse.com', url: 'http://dogs.com', by: 'Dog', project_name: 'Kennel')
      end

      context 'given email address and url' do
        it 'contacts the notification API' do
          simulator.expect_notifier_to_have_been_accessed
        end

        it 'will run send_email with address, url and print url within personalisation hash' do
          simulator.expect_notification(email_address: 'dog@doghouse.com', personalisation: {access_url: 'http://dogs.com', print_url: 'http://dogs.com/print', by: 'Dog', project_name: 'Kennel'})
        end
      end
    end

    context 'example 2' do
      let(:notification_url) { 'https://meow.com/' }

      before do
        ENV['GOV_NOTIFY_API_URL'] = 'https://meow.com'
        simulator.send_notification(to: 'cat@cathouse.com')
        described_class.new.send_return_notification(to: 'cat@cathouse.com', url: 'http://cats.com', by: 'Cat', project_name: 'Flap')
      end

      context 'given email address and url' do
        it 'contacts the notification API' do
          simulator.expect_notifier_to_have_been_accessed
        end

        it 'will run send_email with address, url and print url within personalisation hash' do
          simulator.expect_notification(email_address: 'cat@cathouse.com', personalisation: {access_url: 'http://cats.com', print_url: 'http://cats.com/print', by: 'Cat', project_name: 'Flap'})
        end
      end
    end
  end

  context 'sending a claim submission notification' do
    context 'example 1' do
      let(:notification_url) { 'https://dog.woof/' }
      before do
        ENV['GOV_NOTIFY_API_URL'] = 'https://dog.woof'
        simulator.send_notification(to: 'dog@doghouse.com')
        described_class.new.send_claim_notification(to: 'dog@doghouse.com', url: 'http://dogs.com', by: 'Dog', project_name: 'Kennel')
      end

      context 'given email address and url' do
        it 'contacts the notification API' do
          simulator.expect_notifier_to_have_been_accessed
        end

        it 'will run send_email with address, url and print url within personalisation hash' do
          simulator.expect_notification(email_address: 'dog@doghouse.com', personalisation: {access_url: 'http://dogs.com', print_url: 'http://dogs.com/print', by: 'Dog', project_name: 'Kennel'})
        end
      end
    end

    context 'example 2' do
      let(:notification_url) { 'https://meow.com/' }

      before do
        ENV['GOV_NOTIFY_API_URL'] = 'https://meow.com'
        simulator.send_notification(to: 'cat@cathouse.com')
        described_class.new.send_claim_notification(to: 'cat@cathouse.com', url: 'http://cats.com', by: 'Cat', project_name: 'Flap')
      end

      context 'given email address and url' do
        it 'contacts the notification API' do
          simulator.expect_notifier_to_have_been_accessed
        end

        it 'will run send_email with address, url and print url within personalisation hash' do
          simulator.expect_notification(email_address: 'cat@cathouse.com', personalisation: {access_url: 'http://cats.com', print_url: 'http://cats.com/print', by: 'Cat', project_name: 'Flap'})
        end
      end
    end
  end

  context 'sending a project creation notification' do
    context 'example 1' do
      let(:notification_url) { 'https://dog.woof/' }
      before do
        ENV['GOV_NOTIFY_API_URL'] = 'https://dog.woof'
        simulator.send_notification(to: 'dog@doghouse.com')
        described_class.new.send_project_creation_notification(to: 'dog@doghouse.com', url: 'http://dogs.com')
      end

      context 'given email address and url' do
        it 'contacts the notification API' do
          simulator.expect_notifier_to_have_been_accessed
        end

        it 'will run send_email with address and url within personalisation hash' do
          simulator.expect_notification_to_have_been_sent_with_email(access_url: 'http://dogs.com', email_address: 'dog@doghouse.com')
        end
      end
    end

    context 'example 2' do
      let(:notification_url) { 'https://meow.com/' }

      before do
        ENV['GOV_NOTIFY_API_URL'] = 'https://meow.com'
        simulator.send_notification(to: 'cat@cathouse.com')
        described_class.new.send_project_creation_notification(to: 'cat@cathouse.com', url: 'http://cats.com')
      end

      context 'given email address and url' do
        it 'contacts the notification API' do
          simulator.expect_notifier_to_have_been_accessed
        end

        it 'will run send_email with address and url within personalisation hash' do
          simulator.expect_notification_to_have_been_sent_with_email(access_url: 'http://cats.com', email_address: 'cat@cathouse.com')
        end
      end
    end
  end
end
