# frozen_string_literal: true

class UI::UseCases
  def self.register(builder)
    builder.define_use_case :convert_core_hif_project do
      UI::UseCase::ConvertCoreHIFProject.new
    end

    builder.define_use_case :convert_core_ac_project do
      UI::UseCase::ConvertCoreACProject.new
    end

    builder.define_use_case :convert_core_ff_project do
      UI::UseCase::ConvertCoreFFProject.new
    end

    builder.define_use_case :convert_ui_hif_project do
      UI::UseCase::ConvertUIHIFProject.new
    end

    builder.define_use_case :convert_ui_ac_project do
      UI::UseCase::ConvertUIACProject.new
    end

    builder.define_use_case :convert_ui_ff_project do
      UI::UseCase::ConvertUIFFProject.new
    end

    builder.define_use_case :convert_core_project do
      UI::UseCase::ConvertCoreProject.new(
        convert_core_hif_project: builder.get_use_case(:convert_core_hif_project),
        convert_core_ac_project: builder.get_use_case(:convert_core_ac_project),
        convert_core_ff_project: builder.get_use_case(:convert_core_ff_project)
      )
    end

    builder.define_use_case :convert_ui_project do
      UI::UseCase::ConvertUIProject.new(
        convert_ui_hif_project: builder.get_use_case(:convert_ui_hif_project),
        convert_ui_ac_project: builder.get_use_case(:convert_ui_ac_project),
        convert_ui_ff_project: builder.get_use_case(:convert_ui_ff_project)
      )
    end

    builder.define_use_case :convert_core_hif_return do
      UI::UseCase::ConvertCoreHIFReturn.new
    end

    builder.define_use_case :convert_core_ac_return do
      UI::UseCase::ConvertCoreACReturn.new
    end

    builder.define_use_case :convert_core_ff_return do
      UI::UseCase::ConvertCoreFFReturn.new
    end

    builder.define_use_case :convert_core_return do
      UI::UseCase::ConvertCoreReturn.new(
        convert_core_hif_return: builder.get_use_case(:convert_core_hif_return),
        convert_core_ac_return: builder.get_use_case(:convert_core_ac_return),
        convert_core_ff_return: builder.get_use_case(:convert_core_ff_return)
      )
    end

    builder.define_use_case :convert_ui_hif_return do
      UI::UseCase::ConvertUIHIFReturn.new
    end

    builder.define_use_case :convert_ui_ac_return do
      UI::UseCase::ConvertUIACReturn.new
    end

    builder.define_use_case :convert_ui_ff_return do
      UI::UseCase::ConvertUIFFReturn.new
    end

    builder.define_use_case :convert_ui_return do
      UI::UseCase::ConvertUIReturn.new(
        convert_ui_hif_return: builder.get_use_case(:convert_ui_hif_return),
        convert_ui_ac_return: builder.get_use_case(:convert_ui_ac_return),
        convert_ui_ff_return: builder.get_use_case(:convert_ui_ff_return)
      )
    end

    builder.define_use_case :ui_create_project do
      UI::UseCase::CreateProject.new(
        create_project: builder.get_use_case(:create_new_project),
        convert_ui_project: builder.get_use_case(:convert_ui_project),
        new_project_gateway: builder.get_gateway(:ui_new_project)
      )
    end

    builder.define_use_case :ui_get_project do
      UI::UseCase::GetProject.new(
        find_project: builder.get_use_case(:populate_baseline),
        convert_core_project: builder.get_use_case(:convert_core_project),
        project_schema_gateway: builder.get_gateway(:ui_project_schema)
      )
    end

    builder.define_use_case :ui_update_project do
      UI::UseCase::UpdateProject.new(
        update_project: builder.get_use_case(:update_project),
        convert_ui_project: builder.get_use_case(:convert_ui_project)
      )
    end

    builder.define_use_case :ui_validate_project do
      UI::UseCase::ValidateProject.new(
        project_schema_gateway: builder.get_gateway(:ui_project_schema),
        get_project_template_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end

    builder.define_use_case :ui_validate_return do
      UI::UseCase::ValidateReturn.new(
        return_template_gateway: builder.get_gateway(:ui_return_schema),
        get_return_template_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end

    builder.define_use_case :ui_get_base_return do
      UI::UseCase::GetBaseReturn.new(
        get_base_return: builder.get_use_case(:get_base_return),
        return_schema: builder.get_gateway(:ui_return_schema),
        find_project: builder.get_use_case(:find_project),
        convert_core_return: builder.get_use_case(:convert_core_return)
      )
    end

    builder.define_use_case :ui_create_return do
      UI::UseCase::CreateReturn.new(
        create_return: builder.get_use_case(:create_return),
        find_project: builder.get_use_case(:find_project),
        convert_ui_return: builder.get_use_case(:convert_ui_return)
      )
    end

    builder.define_use_case :ui_update_return do
      UI::UseCase::UpdateReturn.new(
        update_return: builder.get_use_case(:soft_update_return),
        get_return: builder.get_use_case(:get_return),
        convert_ui_return: builder.get_use_case(:convert_ui_return)
      )
    end

    builder.define_use_case :ui_get_return do
      UI::UseCase::GetReturn.new(
        get_return: builder.get_use_case(:pcs_populate_return),
        convert_core_return: builder.get_use_case(:convert_core_return)
      )
    end

    builder.define_use_case :pcs_populate_return do
      LocalAuthority::UseCase::PcsPopulateReturn.new(
        get_return: builder.get_use_case(:get_return),
        pcs_gateway: builder.get_gateway(:pcs)
      )
    end

    builder.define_use_case :ui_get_schema_for_return do
      UI::UseCase::GetSchemaForReturn.new(
        return_template: builder.get_gateway(:ui_return_schema)
      )
    end

    builder.define_use_case :ui_get_returns do
      UI::UseCase::GetReturns.new(
        get_returns: builder.get_use_case(:get_returns),
        find_project: builder.get_use_case(:find_project),
        convert_core_return: builder.get_use_case(:convert_core_return)
      )
    end

    builder.define_use_case :ui_get_base_claim do
      UI::UseCase::GetBaseClaim.new(
        claim_gateway: builder.get_gateway(:ui_claim_schema),
        project_gateway: builder.get_use_case(:find_project),
        get_base_claim: builder.get_use_case(:get_base_claim)
      )
    end

    builder.define_use_case :ui_create_claim do
      UI::UseCase::CreateClaim.new(
        find_project: builder.get_use_case(:find_project),
        create_claim_core: builder.get_use_case(:create_claim),
        convert_ui_claim: builder.get_use_case(:convert_ui_claim)
      )
    end

    builder.define_use_case :convert_ui_claim do
      UI::UseCase::ConvertUIClaim.new(
        convert_ui_ac_claim: builder.get_use_case(:convert_ui_ac_claim),
        convert_ui_hif_claim: builder.get_use_case(:convert_ui_hif_claim),
        convert_ui_ff_claim: builder.get_use_case(:convert_ui_ff_claim)
      )
    end

    builder.define_use_case :convert_ui_ac_claim do
      UI::UseCase::ConvertUIACClaim.new
    end

    builder.define_use_case :convert_ui_hif_claim do
      UI::UseCase::ConvertUIHIFClaim.new
    end

    builder.define_use_case :convert_ui_ff_claim do
      UI::UseCase::ConvertUIFFClaim.new
    end

    builder.define_use_case :ui_get_claim do
      UI::UseCase::GetClaim.new(
        get_claim_core: builder.get_use_case(:pcs_populate_claim),
        claim_schema: builder.get_gateway(:ui_claim_schema),
        convert_core_claim: builder.get_use_case(:convert_core_claim)
      )
    end

    builder.define_use_case :ui_update_claim do
      UI::UseCase::UpdateClaim.new(
        get_claim: builder.get_use_case(:get_claim),
        update_claim_core: builder.get_use_case(:update_claim),
        convert_ui_claim: builder.get_use_case(:convert_ui_claim)
      )
    end

    builder.define_use_case :convert_core_claim do
      UI::UseCase::ConvertCoreClaim.new(
        convert_core_ac_claim: builder.get_use_case(:convert_core_ac_claim),
        convert_core_hif_claim: builder.get_use_case(:convert_core_hif_claim),
        convert_core_ff_claim: builder.get_use_case(:convert_core_ff_claim)
      )
    end

    builder.define_use_case :convert_core_ac_claim do
      UI::UseCase::ConvertCoreACClaim.new
    end

    builder.define_use_case :convert_core_hif_claim do
      UI::UseCase::ConvertCoreHIFClaim.new
    end

    builder.define_use_case :convert_core_ff_claim do
      UI::UseCase::ConvertCoreFFClaim.new
    end

    builder.define_use_case :ui_validate_claim do
      UI::UseCase::ValidateClaim.new(
        claim_template: builder.get_gateway(:ui_claim_schema),
        get_claim_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end
  end
end
