describe HomesEngland::Gateway::Pcs do
  context 'Example 1' do
    let(:pcs_url) { 'meow.cat' }
    let(:pcs_overview_request) do
      stub_request(
        :get,
        "#{pcs_url}/project/HIF%2FMV%2F255"
      ).to_return(
        status: 200,
        body: {
          ProjectManager: "Ed",
          Sponsor: "FIS"
        }.to_json
      ).with(
        headers: {'Authorization' => 'Bearer M.R.I' }
      )
    end

    let(:pcs_actuals_request) do
      stub_request(
        :get,
        "#{pcs_url}/project/HIF%2FMV%2F255/actuals"
      ).to_return(
        status: 200,
        body: [
          {
            dateInfo: {
              period: '2018/19'
            },
            payments: {
              currentYearPayments:
              [111900, 25565, 14159265]
            }
          }
        ].to_json
      ).with(
        headers: {'Authorization' => 'Bearer M.R.I' }
      )
    end

    let(:gateway) { described_class.new }

    before do
      ENV['PCS_URL'] = pcs_url
      pcs_overview_request
      pcs_actuals_request
      gateway
    end

    it 'Calls the PCS overview endpoint' do
      gateway.get_project(bid_id: 'HIF/MV/255', api_key: 'M.R.I')
      expect(pcs_overview_request).to have_been_requested
    end

    it 'Calls the PCS actuals endpoint' do
      gateway.get_project(bid_id: 'HIF/MV/255', api_key: 'M.R.I')
      expect(pcs_actuals_request).to have_been_requested
    end

    it 'Returns a domain object' do
      project = gateway.get_project(bid_id: 'HIF/MV/255', api_key: 'M.R.I')

      expect(project.project_manager).to eq("Ed")
      expect(project.sponsor).to eq("FIS")
      expect(project.actuals).to eq([
        {
          dateInfo: {
            period: '2018/19'
          },
          payments: {
            currentYearPayments:
            [111900, 25565, 14159265]
          }
        }
      ])
    end
  end

  context 'Example 2' do
    let(:pcs_url) { 'meow.space' }
    let(:pcs_overview_request) do
      stub_request(
        :get,
        "#{pcs_url}/project/AC%2FMV%2F151"
      ).to_return(
          status: 200, body: {
          ProjectManager: "Natalia",
          Sponsor: "NHN"
        }.to_json
      ).with(
        headers: {'Authorization' => 'Bearer C.C.G' }
      )
    end

    let(:pcs_actuals_request) do
      stub_request(
        :get,
        "#{pcs_url}/project/AC%2FMV%2F151/actuals"
      ).to_return(
        status: 200,
        body: [
          {
            dateInfo: {
              period: '2007/2008'
            },
            payments: {
              currentYearPayments:
              [800999, 41199, 1989, 2012]
            }
          }
        ].to_json
      ).with(
        headers: {'Authorization' => 'Bearer C.C.G' }
      )
    end

    let(:gateway) { described_class.new }

    before do
      ENV['PCS_URL'] = pcs_url
      pcs_overview_request
      pcs_actuals_request
      gateway
    end

    it 'Calls the PCS overview endpoint' do
      gateway.get_project(bid_id: 'AC/MV/151', api_key: 'C.C.G')
      expect(pcs_overview_request).to have_been_requested
    end

    it 'Calls the PCS actuals endpoint' do
      gateway.get_project(bid_id: 'AC/MV/151', api_key: 'C.C.G')
      expect(pcs_actuals_request).to have_been_requested
    end

    it 'Returns a domain object' do
      project = gateway.get_project(bid_id: 'AC/MV/151', api_key: 'C.C.G')

      expect(project.project_manager).to eq("Natalia")
      expect(project.sponsor).to eq("NHN")
      expect(project.actuals).to eq([
        {
          dateInfo: {
            period: '2007/2008'
          },
          payments: {
            currentYearPayments:
            [800999, 41199, 1989, 2012]
          }
        }
      ])
    end
  end
end
