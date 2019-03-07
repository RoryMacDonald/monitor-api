describe LocalAuthority::Gateway::SequelClaim do
  include_context 'with database'
  let(:gateway) { described_class.new(database: database) }


  context 'example 1' do
    let(:project_id) { database[:projects].insert(type: 'hif', bid_id: 'HIF/MV/151') }

    it 'creates the claim' do
      claim_to_create = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Draft'
        claim.data = {
          claimSummary: {
            TotalFundingRequest: "255"
          }
        }
      end

      id = gateway.create(claim_to_create)
      found_claim = gateway.find_by(claim_id: id)
      expect(found_claim.id).to eq(id)
      expect(found_claim.project_id).to eq(project_id)
      expect(found_claim.type).to eq('hif')
      expect(found_claim.status).to eq('Draft')
      expect(found_claim.bid_id).to eq('HIF/MV/151')
      expect(found_claim.data).to eq(
        {
          claimSummary: {
            TotalFundingRequest: "255"
          }
        }
      )
    end

    it 'Updates the claim' do
      claim_to_create = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Draft'
        claim.data = {}
      end

      id = gateway.create(claim_to_create)

      claim_to_update = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.data = { claim_name: "my claim"}
      end

      gateway.update(claim_id: id, claim: claim_to_update)
      found_claim = gateway.find_by(claim_id: id)
      expect(found_claim.data).to eq({ claim_name: "my claim" })
    end

    it 'Submits the claim' do
      claim_to_create = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Draft'
        claim.data = {}
      end

      id = gateway.create(claim_to_create)

      gateway.submit(claim_id: id)

      found_claim = gateway.find_by(claim_id: id)
      expect(found_claim.status).to eq('Submitted')
    end

    it 'gets all the claims' do
      first_claim = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Submitted'
        claim.data = { claim: 'data' }
      end

      second_claim = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Draft'
        claim.data = { more_data: 'second_return' }
      end

      gateway.create(first_claim)
      gateway.create(second_claim)
      
      response = gateway.get_all(project_id: project_id)

      expect(response[0].project_id).to eq(project_id)
      expect(response[0].status).to eq('Submitted')
      expect(response[0].data).to eq({ claim: 'data' })

      expect(response[1].project_id).to eq(project_id)
      expect(response[1].status).to eq('Draft')
      expect(response[1].data).to eq({ more_data: 'second_return' })
    end
  end

  context 'example 2' do
    let(:project_id) { database[:projects].insert(type: 'ac', bid_id: 'AC/MV/1') }

    it 'creates the claim' do
      claim_to_create = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Submitted'
        claim.data = {
          claimSummary: {
            TotalFundingRequest: "3",
            hifSpendToDate: "1119003331"
          }
        }
      end

      id = gateway.create(claim_to_create)
      found_claim = gateway.find_by(claim_id: id)
      expect(found_claim.id).to eq(id)
      expect(found_claim.project_id).to eq(project_id)
      expect(found_claim.type).to eq('ac')
      expect(found_claim.status).to eq('Submitted')
      expect(found_claim.bid_id).to eq('AC/MV/1')
      expect(found_claim.data).to eq(
        {
          claimSummary: {
            TotalFundingRequest: "3",
            hifSpendToDate: "1119003331"
          }
        }
      )
    end

    it 'Updates the claim' do
      claim_to_create = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.project_id = project_id
        claim.status = 'Draft'
        claim.data = { claim_summary: "new claim"}
      end

      id = gateway.create(claim_to_create)

      claim_to_update = LocalAuthority::Domain::Claim.new.tap do |claim|
        claim.data = { claim_summary: "a claim"}
      end

      gateway.update(claim_id: id, claim: claim_to_update)
      found_claim = gateway.find_by(claim_id: id)
      expect(found_claim.data).to eq({ claim_summary: "a claim" })
    end
  end
end
