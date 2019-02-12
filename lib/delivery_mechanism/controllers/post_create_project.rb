module DeliveryMechanism
  module Controllers
    class PostCreateProject
      def initialize(create_new_project:)
        @create_new_project = create_new_project
      end

      def execute(params, request_hash, response)
        return response.status = 400 unless request_hash[:name]

        id = @create_new_project.execute(
          name: request_hash[:name],
          type: request_hash[:type],
          bid_id: request_hash[:bid_id],
          baseline: Common::DeepSymbolizeKeys.to_symbolized_hash(request_hash[:baselineData])
        )


        response.body = {
          projectId: id
        }.to_json
        response.status = 201
      end
    end
  end
end
