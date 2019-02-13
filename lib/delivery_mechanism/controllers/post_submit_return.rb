module DeliveryMechanism
  module Controllers
    class PostSubmitReturn
      def initialize(submit_return:, notify_project_members_of_submission:, check_api_key:)
        @submit_return = submit_return
        @notify_project_members_of_submission = notify_project_members_of_submission
        @check_api_key = check_api_key
      end

      def execute(env, request, request_hash, response)
        actor_email = @check_api_key.execute(
          api_key: env['HTTP_API_KEY'],
          project_id: request_hash[:project_id]
        )[:email]

        @submit_return.execute(
          return_id: request_hash[:return_id].to_i
        )

        @notify_project_members_of_submission.execute(
          project_id: request_hash[:project_id].to_i,
          url: request_hash[:url],
          by: actor_email
        )

        response.status = 200
      end
    end
  end
end
