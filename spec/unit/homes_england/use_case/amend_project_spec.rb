describe HomesEngland::UseCase::AmendProject do
  let(:project_gateway) { spy(update_project: nil, increment_version: nil) }
  let(:usecase) { described_class.new(project_gateway: project_gateway)}

  context 'example 1' do
    usecase.execute(project_id: 1, data:)
  end

  context 'example 2' do

  end
end
