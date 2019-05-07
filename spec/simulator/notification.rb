module Simulator
  class Notification
    extend Forwardable

    def_delegators :@test_suite, :expect, :eq, :have_been_made, :hash_including, :include

    def initialize(test_suite, url)
      @test_suite = test_suite
      @url = url
    end

    def stub_send_notification(to:)
      @stub_request = @test_suite.stub_request(
        :post,
        "#{@url}v2/notifications/email").with(
          body: hash_including(email_address: to)
        ).to_return(status: 200, body: {}.to_json)
    end

    def expect_notification_to_have_been_sent_with(access_url:)
      expect(@stub_request.with do |req|
        request_body = JSON.parse(req.body)
        expect(request_body["personalisation"]["access_url"]).to eq(access_url)
      end).to have_been_made
    end

    def expect_notification_to_have_been_sent_with_email(access_url:, email_address:)
      expect(@stub_request.with do |req|
        request_body = JSON.parse(req.body)
        expect(request_body["email_address"]).to eq(email_address)
        expect(request_body["personalisation"]["access_url"]).to eq(access_url)
      end).to have_been_made
    end

    def expect_notification(email_address:, personalisation:)
      expect(@stub_request.with do |req|
        request_body = JSON.parse(req.body)
        request_hash = Common::DeepSymbolizeKeys.to_symbolized_hash(request_body)
        expect(request_hash[:email_address]).to eq(email_address)
        expect(request_hash[:personalisation]).to include(personalisation)
      end).to have_been_made
    end

    def expect_notifier_to_have_been_accessed
      expect(@stub_request).to have_been_made
    end
  end
end
