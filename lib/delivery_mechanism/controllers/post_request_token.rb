module DeliveryMechanism
  module Controllers
    class PostRequestToken
      def initialize(check_email:, send_notification:, create_access_token:)
        @check_email = check_email
        @send_notification = send_notification
        @create_access_token = create_access_token
      end

      def execute(request, response)
        @request = request

        if email_address_valid?
          send_notification
          response.status = 200
        else
          response.status = 403
        end
      end

      private

      def email_address_valid?
        @check_email.execute(
          email_address: @request[:email_address]
        )[:valid]
      end

      def send_notification
        @send_notification.execute(
          to: @request[:email_address], url: @request[:url],
          access_token: access_token_for_project
        )
      end

      def access_token_for_project
        @create_access_token.execute(email: @request[:email_address])[:access_token]
      end
    end
  end
end
