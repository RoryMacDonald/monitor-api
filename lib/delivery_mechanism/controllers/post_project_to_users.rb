module DeliveryMechanism
  module Controllers
    class PostProjectToUsers
      def initialize(add_user_to_project:)
        @add_user_to_project = add_user_to_project
      end

      def execute(params, request_hash, response)
        user_emails = request_hash[:users]

        return 400 unless user_emails.instance_of? Array

        user_emails.each do |user_info|
          @add_user_to_project.execute({ email: user_info[:email], role: user_info[:role], project_id: params[:id].to_i })
        end
        response.status = 200
        response
      end
    end
  end
end
