# frozen_string_literal: true

describe UI::UseCase::GetClaims do
  context 'Example one' do
    let(:convert_core_claim_spy) { spy(execute: { rabbit: 'hops' }) }
    let(:find_project_spy) { spy(execute: { type: 'nil' }) }
    let(:get_claims_spy) do
      spy(execute: {
            claims:
            [{
              id: 1,
              project_id: 2,
              status: 'completed',
              data: { bird: 'squarrrkk' }
            }]
          })
    end
    let(:use_case) do
      described_class.new(
        get_claims: get_claims_spy,
        find_project: find_project_spy,
        convert_core_claim: convert_core_claim_spy
      )
    end
    let(:response) { use_case.execute(project_id: 2) }

    before { response }

    it 'Calls execute on the get claims usecase' do
      expect(get_claims_spy).to have_received(:execute)
    end

    it 'Passes the project ID to the get claims use case' do
      expect(get_claims_spy).to have_received(:execute).with(project_id: 2)
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'Calls the convert core claim use case with the data' do
      expect(convert_core_claim_spy).to(
        have_received(:execute)
        .with(claim_data: { bird: 'squarrrkk' }, type: 'nil')
      )
    end

    it 'returns converted claims' do
      expect(response[:claims][0][:data]).to eq({ rabbit: 'hops' })
    end
  end

  context 'Example two' do
    let(:convert_core_claim_spy) { spy(execute: { toad: 'ribbit' }) }
    let(:find_project_spy) { spy(execute: { type: 'non' }) }
    let(:get_claims_spy) do
      spy(execute: {
            claims: [{
              id: 3,
              project_id: 7,
              status: 'not done',
              data: { dog: 'woof' }
            }]
          })
    end
    let(:use_case) do
      described_class.new(
        get_claims: get_claims_spy,
        find_project: find_project_spy,
        convert_core_claim: convert_core_claim_spy
      )
    end
    let(:response) { use_case.execute(project_id: 7) }

    before { response }

    it 'Calls execute on the get claims usecase' do
      expect(get_claims_spy).to have_received(:execute)
    end

    it 'Passes the project ID to the get claims use case' do
      expect(get_claims_spy).to have_received(:execute).with(project_id: 7)
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    it 'Calls the convert core claim use case with the data' do
      expect(convert_core_claim_spy).to(
        have_received(:execute)
        .once
        .with(claim_data: { dog: 'woof' }, type: 'non')
      )
    end

    it 'returns converted claims' do
      expect(response[:claims]).to(eq(
                                      [
                                        {
                                          id: 3,
                                          project_id: 7,
                                          status: 'not done',
                                          data: { toad: 'ribbit' }
                                        }
                                      ]
                                    ))
    end
  end
end
