# frozen_string_literal: true

class HomesEngland::UseCases
  def self.register(builder)
    builder.define_use_case :create_new_project do
      HomesEngland::UseCase::CreateNewProject.new(
        project_gateway: builder.get_gateway(:project),
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :find_project do
      HomesEngland::UseCase::FindProject.new(
        project_gateway: builder.get_gateway(:project),
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :update_project do
      HomesEngland::UseCase::UpdateProject.new(
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :validate_project do
      HomesEngland::UseCase::ValidateProject.new(
        project_template_gateway: builder.get_gateway(:template),
        get_project_template_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end

    builder.define_use_case :submit_project do
      HomesEngland::UseCase::SubmitProject.new(
        project_gateway: builder.get_gateway(:project),
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :unsubmit_project do
      HomesEngland::UseCase::UnSubmitProject.new(
        project_gateway: builder.get_gateway(:project),
        return_gateway: builder.get_gateway(:return_gateway)
      )
    end

    builder.define_use_case :get_schema_for_project do
      HomesEngland::UseCase::GetSchemaForProject.new(
        template_gateway: builder.get_gateway(:template)
      )
    end

    builder.define_use_case :populate_template do
      HomesEngland::UseCase::PopulateTemplate.new(
        template_gateway: builder.get_gateway(:template)
      )
    end

    builder.define_use_case :add_user do
      HomesEngland::UseCase::AddUser.new(
        user_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :change_user_role do
      HomesEngland::UseCase::ChangeUserRole.new(
        user_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :delete_user do
      HomesEngland::UseCase::DeleteUser.new(
        user_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :add_user_to_project do
      HomesEngland::UseCase::AddUserToProject.new(
        user_gateway: builder.get_gateway(:users),
        project_gateway: builder.get_gateway(:project)
      )
    end

    builder.define_use_case :get_project_users do
      HomesEngland::UseCase::GetProjectUsers.new(
        user_gateway: builder.get_gateway(:users)
      )
    end

    builder.define_use_case :send_project_creation_notification do
      HomesEngland::UseCase::SendProjectCreationNotification.new(
        email_notification_gateway: builder.get_gateway(:notification)
      )
    end

    builder.define_use_case :notify_project_members_of_creation do
      HomesEngland::UseCase::NotifyProjectMembersOfCreation.new(
        send_project_creation_notification: builder.get_use_case(:send_project_creation_notification),
        get_project_users: builder.get_use_case(:get_project_users)
      )
    end

    builder.define_use_case :export_project_data do
      HomesEngland::UseCase::ExportProjectData.new(
        find_project: builder.get_use_case(:find_project),
        get_returns: builder.get_use_case(:get_returns)
      )
    end

    builder.define_use_case :export_all_projects do
      HomesEngland::UseCase::ExportAllProjects.new(
        export_project: builder.get_use_case(:export_project_data),
        project_gateway: builder.get_gateway(:project)
      )
    end

    builder.define_use_case :populate_baseline do
      HomesEngland::UseCase::PopulateBaseline.new(
        find_project: builder.get_use_case(:find_project),
        pcs_gateway: builder.get_gateway(:pcs)
      )
    end

    builder.define_use_case :amend_baseline do
      HomesEngland::UseCase::AmendBaseline.new(
        project_gateway: builder.get_gateway(:project),
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :get_baselines do
      HomesEngland::UseCase::GetBaselines.new(
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :submit_baseline do
      HomesEngland::UseCase::SubmitBaseline.new(
        baseline_gateway: builder.get_gateway(:baseline)
      )
    end

    builder.define_use_case :get_project_overview do
      HomesEngland::UseCase::GetProjectOverview.new(
        baseline_gateway: builder.get_gateway(:baseline),
        claim_gateway: builder.get_gateway(:claim),
        find_project: builder.get_use_case(:find_project),
        return_gateway: builder.get_gateway(:return_gateway)
      )
    end
  end
end
