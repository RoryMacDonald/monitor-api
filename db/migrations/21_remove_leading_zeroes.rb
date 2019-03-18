# frozen_string_literal: true

Sequel.migration do
  up do
    projects = from(:projects)
    projects.each do |project|
      bid_id = remove_leading_zeroes(project[:bid_id])
      from(:projects).where(id: project[:id]).update(bid_id: bid_id)
    end
  end

  down do
  end
end

def remove_leading_zeroes(bid_id)
  bid_id.sub(/[0]+([1-9][0-9]*)/, "\\1")
end
