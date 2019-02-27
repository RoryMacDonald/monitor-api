describe UI::UseCase::GetClaim do
  context 'example 1' do
    let(:get_claim_core_spy) do
      spy(
        execute: {
          id: 7,
          type: 'hif',
          bid_id: 'HIF/MV/535',
          project_id: 11,
          status: 'Draft',
          data: {
            hif_data: 'a hif project'
          }
        }
      )
    end

    let(:claim_schema_spy) do
      spy(
        find_by:
        Common::Domain::Template.new.tap do |template|
          template.schema = { template_data: 'template value' }
        end
      )
    end
    let(:convert_core_spy) do
      spy(
        execute: { hif_data: 'converted hif project' }
      )
    end
    let(:usecase) do
      described_class.new(
        get_claim_core: get_claim_core_spy,
        claim_schema: claim_schema_spy,
        convert_core_claim: convert_core_spy
      )
    end

    it 'calls the get claim core usecase' do
      usecase.execute(claim_id: 6)
      expect(get_claim_core_spy).to have_received(:execute).with(claim_id: 6)
    end

    it 'calls the get claim schema usecase' do
      usecase.execute(claim_id: 6)
      expect(claim_schema_spy).to have_received(:find_by).with(type: 'hif')
    end


    it 'calls the convert core usecase' do
      usecase.execute(claim_id: 6)
      expect(convert_core_spy).to have_received(:execute).with(
        claim_data: {
          hif_data: 'a hif project'
        },
        type: 'hif'
      )
    end

    it 'returns the correct data' do
      response = usecase.execute(claim_id: 6)
      expect(response[:id]).to eq(7)
      expect(response[:project_id]).to eq(11)
      expect(response[:status]).to eq('Draft')
      expect(response[:bid_id]).to eq('HIF/MV/535')
      expect(response[:type]).to eq('hif')
      expect(response[:schema]).to eq({ template_data: 'template value' })
      expect(response[:data]).to eq({ hif_data: 'converted hif project' })
    end
  end

  context 'example 2' do
    let(:get_claim_core_spy) do
      spy(
        execute: {
          id: 24,
          type: 'ac',
          project_id: 7,
          bid_id: 'AC/MV/5',
          status: 'Submitted',
          data: {
            ac_data: 'an ac project'
          }
        }
      )
    end

    let(:claim_schema_spy) do
      spy(
        find_by:
        Common::Domain::Template.new.tap do |template|
          template.schema = { data: 'value' }
        end
      )
    end
    let(:convert_core_spy) do
      spy(
        execute: { ac_data: 'converted ac project' }
      )
    end
    let(:usecase) do
      described_class.new(
        get_claim_core: get_claim_core_spy,
        claim_schema: claim_schema_spy,
        convert_core_claim: convert_core_spy
      )
    end

    it 'calls the get claim core usecase' do
      usecase.execute(claim_id: 9)
      expect(get_claim_core_spy).to have_received(:execute).with(claim_id: 9)
    end

    it 'calls the get claim schema usecase' do
      usecase.execute(claim_id: 9)
      expect(claim_schema_spy).to have_received(:find_by).with(type: 'ac')
    end


    it 'calls the convert core usecase' do
      usecase.execute(claim_id: 6)
      expect(convert_core_spy).to have_received(:execute).with(
        claim_data: {
          ac_data: 'an ac project'
        },
        type: 'ac'
      )
    end

    it 'returns the correct data' do
      response = usecase.execute(claim_id: 9)
      expect(response[:id]).to eq(24)
      expect(response[:project_id]).to eq(7)
      expect(response[:status]).to eq('Submitted')
      expect(response[:type]).to eq('ac')
      expect(response[:bid_id]).to eq('AC/MV/5')
      expect(response[:schema]).to eq({ data: 'value' })
      expect(response[:data]).to eq({ ac_data: 'converted ac project' })
    end
  end
end
