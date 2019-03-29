# frozen_string_literal: true

class UI::Gateway::InMemoryReturnSchema
  def find_by(type:)
    if type == 'hif'
      schema = 'hif_return.json'
    elsif type == 'ac'
      schema = 'ac_return.json'
    else
      return nil
    end

    create_template(schema, type)
  end

  private

  def create_template(schema, type)
    @template = Common::Domain::Template.new

    File.open("#{__dir__}/schemas/#{schema}", 'r') do |f|
      @template.schema = Common::PreprocessJSON.parse(f.read)
    end

    check_hif_tab_flags if type == 'hif'

    @template
  end

  def check_hif_tab_flags
    delete_s151_tab if ENV['S151_TAB'].nil?
    delete_confirmation_tab if ENV['CONFIRMATION_TAB'].nil?
    delete_outputs_forcast_tab if ENV['OUTPUTS_FORECAST_TAB'].nil?
    delete_outputs_actuals_tab if ENV['OUTPUTS_ACTUALS_TAB'].nil?
    delete_wider_scheme_tab if ENV['WIDER_SCHEME_TAB'].nil?
    delete_rm_monthly_catchup_tab if ENV['RM_MONTHLY_CATCHUP_TAB'].nil?
    delete_mr_review_tab if ENV['MR_REVIEW_TAB'].nil?
    delete_hif_recovery_tab if ENV['HIF_RECOVERY_TAB'].nil?
  end

  def delete_s151_tab
    @template.schema[:properties].delete(:s151)
  end

  def delete_confirmation_tab
    @template.schema[:properties].delete(:s151Confirmation)
  end

  def delete_outputs_forcast_tab
    @template.schema[:properties].delete(:outputsForecast)
  end

  def delete_outputs_actuals_tab
    @template.schema[:properties].delete(:outputsActuals)
  end

  def delete_wider_scheme_tab
    @template.schema[:properties].delete(:widerScheme)
  end

  def delete_rm_monthly_catchup_tab
    @template.schema[:properties].delete(:rmMonthlyCatchup)
  end

  def delete_mr_review_tab
    @template.schema[:properties].delete(:reviewAndAssurance)
  end

  def delete_hif_recovery_tab
    @template.schema[:properties].delete(:hifRecovery)
  end
end
