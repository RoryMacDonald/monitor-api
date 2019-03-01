# frozen_string_literal: true

class UI::UseCase::ConvertCoreFFProject
  def execute(project_data:)
    @project = project_data

    @converted_project = {}

    convert_infrastructures
    convert_summary
    convert_planning
    convert_land_owenership
    convert_procurement

    @converted_project
  end

  private

  def convert_infrastructures
    return if @project[:infrastructures].nil?

    @converted_project[:infrastructures] = @project[:infrastructures]
  end

  def convert_summary
    return if @project[:summary].nil?

    @converted_project[:summary] = @project[:summary]
  end

  def convert_planning
    return if @project[:planning].nil?

    @converted_project[:planning] = @project[:planning]
  end

  def convert_land_owenership
    return if @project[:landOwenership].nil?

    @converted_project[:landOwenership] = @project[:landOwenership]
  end

  def convert_procurement
    return if @project[:procurement].nil?

    @converted_project[:procurement] = @project[:procurement]
  end
end
