# frozen_string_literal: true

class LocalAuthority::UseCases
  def self.register(builder)
    builder.define_use_case :api_to_pcs_key do
      LocalAuthority::UseCase::ApiToPcsKey.new
    end

    builder.define_use_case :find_path_data do
      LocalAuthority::UseCase::FindPathData.new
    end

    builder.define_use_case :get_schema_copy_paths do
      LocalAuthority::UseCase::GetSchemaCopyPaths.new(
        template_gateway: builder.get_gateway(:return_template)
      )
    end

    builder.define_use_case :populate_return_template do
      LocalAuthority::UseCase::PopulateReturnTemplate.new(
        find_path_data: builder.get_use_case(:find_path_data),
        get_schema_copy_paths: builder.get_use_case(:get_schema_copy_paths),
        get_return_template_path_types: builder.get_use_case(:get_return_template_path_types)
      )
    end

    builder.define_use_case :get_base_return do
      LocalAuthority::UseCase::GetBaseReturn.new(
        return_gateway: builder.get_gateway(:return_template),
        project_gateway: builder.get_gateway(:project),
        populate_return_template: builder.get_use_case(:populate_return_template),
        get_returns: builder.get_use_case(:get_returns)
      )
    end

    builder.define_use_case :create_return do
      LocalAuthority::UseCase::CreateReturn.new(
        return_gateway: builder.get_gateway(:return_gateway),
        return_update_gateway: builder.get_gateway(:return_update_gateway),
        find_project: builder.get_use_case(:find_project)
      )
    end

    builder.define_use_case :update_return do
      LocalAuthority::UseCase::UpdateReturn.new(
        return_gateway: builder.get_gateway(:return_gateway)
      )
    end

    builder.define_use_case :soft_update_return do
      LocalAuthority::UseCase::SoftUpdateReturn.new(
        return_update_gateway: builder.get_gateway(:return_update_gateway)
      )
    end

    builder.define_use_case :get_return do
      LocalAuthority::UseCase::GetReturn.new(
        return_gateway: builder.get_gateway(:return_gateway),
        return_update_gateway: builder.get_gateway(:return_update_gateway),
        get_returns: builder.get_use_case(:get_returns)
      )
    end

    builder.define_use_case :submit_return do
      LocalAuthority::UseCase::SubmitReturn.new(
        return_gateway: builder.get_gateway(:return_gateway)
      )
    end

    builder.define_use_case :get_schema_for_return do
      LocalAuthority::UseCase::GetSchemaForReturn.new(
        project_gateway: builder.get_gateway(:project),
        return_gateway: builder.get_gateway(:return_gateway),
        template_gateway: builder.get_gateway(:return_template)
      )
    end

    builder.define_use_case :get_returns do
      LocalAuthority::UseCase::GetReturns.new(
        return_gateway: builder.get_gateway(:return_gateway),
        return_update_gateway: builder.get_gateway(:return_update_gateway)
      )
    end

    builder.define_use_case :check_email do
      LocalAuthority::UseCase::CheckEmail.new(
        users_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :create_access_token do
      LocalAuthority::UseCase::CreateAccessToken.new(
        access_token_gateway: builder.get_gateway(
          :access_token
        ),
        user_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :expend_access_token do
      LocalAuthority::UseCase::ExpendAccessToken.new(
        access_token_gateway: builder.get_gateway(
          :access_token
        ), create_api_key: builder.get_use_case(:create_api_key)
      )
    end

    builder.define_use_case :create_api_key do
      LocalAuthority::UseCase::CreateApiKey.new
    end

    builder.define_use_case :get_user_projects do
      LocalAuthority::UseCase::GetUserProjects.new(
        project_gateway: builder.get_gateway(:project),
        user_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :send_notification do
      LocalAuthority::UseCase::SendNotification.new(
        notification_gateway: builder.get_gateway(:notification)
      )
    end

    builder.define_use_case :check_api_key do
      LocalAuthority::UseCase::CheckApiKey.new
    end

    builder.define_use_case :validate_return do
      LocalAuthority::UseCase::ValidateReturn.new(
        return_template_gateway: builder.get_gateway(:return_template),
        get_return_template_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end

    builder.define_use_case :get_return_template_path_types do
      LocalAuthority::UseCase::GetReturnTemplatePathTypes.new(
        template_gateway: builder.get_gateway(:return_template)
      )
    end

    builder.define_use_case :send_return_submission_notification do
      LocalAuthority::UseCase::SendReturnSubmissionNotification.new(
        email_notification_gateway: builder.get_gateway(:notification)
      )
    end

    builder.define_use_case :notify_project_members_of_submission do
      LocalAuthority::UseCase::NotifyProjectMembers.new(
        send_return_submission_notification: builder.get_use_case(:send_return_submission_notification),
        get_project_users: builder.get_use_case(:get_project_users),
        find_project: builder.get_use_case(:find_project)
      )
    end
  end
end
