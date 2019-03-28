# frozen_string_literal: true

 Sequel.migration do
  up do
    projects = from(:projects)
    projects.each do |project|
      next unless project[:type] == 'hif'

       project_baselines = from(:baselines).where(project_id: project[:id]).all

       project_baselines.each do |baseline|
        new_data = baseline[:data]

        next unless new_data['rmBaseline'] 

        if new_data['rmBaseline']['mhclgLinks']
          new_data['rmBaseline']['mhclgProgrammeLinks'] = [new_data['rmBaseline']['mhclgLinks']]
        end

        if new_data['rmBaseline']['ogdLinks']
          new_data['rmBaseline']['ogdProgrammeLinks'] = [new_data['rmBaseline']['ogdLinks']]
        end

        if new_data['rmBaseline']['otherGovDepts']
          new_data['rmBaseline']['otherLinkedGovDepts'] = [new_data['rmBaseline']['otherGovDepts']]
        end

        if new_data['rmBaseline']['housingPolicyAreas']
          new_data['rmBaseline']['linekdHousingPolicyAreas'] = [new_data['rmBaseline']['housingPolicyAreas']]
        end

        if new_data['rmBaseline']['heProgrammeLinks']
          new_data['rmBaseline']['heProgrammeLinksMultiple'] = [new_data['rmBaseline']['heProgrammeLinks']]
        end

         from(:baselines).where(id: baseline[:id]).update(data: new_data)
      end
    end
  end

   down do
  end
end