# frozen_string_literal: true

Sequel.migration do
  up do
    projects = from(:projects)
    projects.each do |project|
      bid_reference = project.dig(:data, 'summary', 'BIDReference')
      from(:projects).where(id: project[:id]).update(bid_id: bid_reference)
    end
  end

  down do
  end
end
