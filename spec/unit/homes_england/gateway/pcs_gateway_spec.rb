describe HomesEngland::Gateway::Pcs do
  context 'Example 1' do
    let(:pcs_url) { 'meow.cat' }
    let(:pcs_request) do
      stub_request(:get, "#{pcs_url}/project/HIF%2FMV%2F255").to_return(status: 200, body: {
        ProjectManager: "Ed",
        Sponsor: "FIS"
      }.to_json)
    end

    let(:gateway) { described_class.new }

    before do
      ENV['PCS_URL'] = pcs_url
      pcs_request
      gateway
    end

    it 'Calls the PCS endpoint' do
      gateway.get_project(bid_id: 'HIF/MV/255')
      expect(pcs_request).to have_been_requested
    end

    it 'Returns a domain object' do
      project = gateway.get_project(bid_id: 'HIF/MV/255')

      expect(project.project_manager).to eq("Ed")
      expect(project.sponsor).to eq("FIS")
    end
  end

  context 'Example 2' do
    let(:pcs_url) { 'meow.space' }
    let(:pcs_request) do
      stub_request(:get, "#{pcs_url}/project/AC%2FMV%2F151").to_return(status: 200, body: {
        ProjectManager: "Natalia",
        Sponsor: "NHN"
      }.to_json)
    end

    let(:gateway) { described_class.new }

    before do
      ENV['PCS_URL'] = pcs_url
      pcs_request
      gateway
    end

    it 'Calls the PCS endpoint' do
      gateway.get_project(bid_id: 'AC/MV/151')
      expect(pcs_request).to have_been_requested
    end

    it 'Returns a domain object' do
      project = gateway.get_project(bid_id: 'AC/MV/151')

      expect(project.project_manager).to eq("Natalia")
      expect(project.sponsor).to eq("NHN")
    end
  end
end
