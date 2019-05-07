RSpec.shared_context 'project fixtures' do
  let(:hif_mvf_core_project_baseline) do
    File.open("#{__dir__}/../../fixtures/hif_baseline_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end
end
