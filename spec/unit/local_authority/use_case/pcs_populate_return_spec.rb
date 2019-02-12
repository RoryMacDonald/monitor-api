describe LocalAuthority::UseCase::PcsPopulateReturn do
  context 'example 1' do
    let(:bid_id) { 'HIF/MV/65' }
    let(:get_return_spy) do
      spy(
        execute: {
          id: 1,
          bid_id: bid_id,
          type: 'hif',
          project_id: 2,
          status: 'Draft',
          updates: [{ dog: 'woof' }, { dog: 'woof' }]
        }
      )
    end

    let(:pcs_gateway_spy) do
      spy(
        get_project: [
          {
            previousYearPaymentsToDate: 6.28
          }
        ]
      )
    end

    let(:use_case) do
      described_class.new(
        get_return: get_return_spy,
        pcs_gateway: pcs_gateway_spy
      )
    end


    it 'Calls the get return use case' do
      use_case.execute(id: 1, api_key: 'M.V.C')
      expect(get_return_spy).to have_received(:execute).with(id: 1)
    end

    context 'unsubmitted' do
      it 'Calls the PCS use case' do
        use_case.execute(id: 1, api_key: 'M.V.C')
        expect(pcs_gateway_spy).to have_received(:get_project).with(api_key: 'M.V.C', bid_id: bid_id)
      end
    end

    context 'submitted' do
      let(:get_return_spy) do
        spy(
          execute: {
            id: 1,
            bid_id: bid_id,
            type: 'hif',
            project_id: 2,
            status: 'Submitted',
            updates: [{ dog: 'woof' }, { dog: 'woof' }]
          }
        )
      end

      it 'Does not call the PCS use case' do
        use_case.execute(id: 1, api_key: 'M.V.C')
        expect(pcs_gateway_spy).not_to have_received(:get_project)
      end
    end

    it 'returns the appropriate data' do
      expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
        {
          id: 1,
          bid_id: bid_id,
          type: 'hif',
          project_id: 2,
          status: 'Draft',
          updates: [{ dog: 'woof' }, { dog: 'woof' }]
        }
      )
    end
  end

  context 'example 2' do
    let(:bid_id) { 'AC/MV/11' }
    let(:get_return_spy) do
      spy(
        execute: {
          id: 3,
          bid_id: bid_id,
          type: 'ac',
          project_id: 2,
          status: 'Draft',
          updates: [{ dog: 'woof' }, { dog: 'woof' }]
        }
      )
    end

    let(:pcs_gateway_spy) do
      spy(
        get_project: [
          {
            previousYearPaymentsToDate: 3.14
          }
        ]
      )
    end

    let(:use_case) do
      described_class.new(
        get_return: get_return_spy,
        pcs_gateway: pcs_gateway_spy
      )
    end

    it 'Calls the get return use case' do
      use_case.execute(id: 3, api_key: 'M.R.W')
      expect(get_return_spy).to have_received(:execute).with(id: 3)
    end

    it 'returns the appropriate data' do
      expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
        {
          id: 3,
          bid_id: bid_id,
          type: 'ac',
          project_id: 2,
          status: 'Draft',
          updates: [{ dog: 'woof' }, { dog: 'woof' }]
        }
      )
    end

    context 'unsubmitted' do
      it 'Calls the PCS use case' do
        use_case.execute(id: 3, api_key: 'M.R.W')
        expect(pcs_gateway_spy).to have_received(:get_project).with(api_key: 'M.R.W', bid_id: bid_id)
      end
    end

    context 'submitted' do
      let(:get_return_spy) do
        spy(
          execute: {
            id: 3,
            bid_id: bid_id,
            type: 'ac',
            project_id: 2,
            status: 'Submitted',
            updates: [{ dog: 'woof' }, { dog: 'woof' }]
          }
        )
      end

      it 'Does not call the PCS use case' do
        use_case.execute(id: 3, api_key: 'M.R.W')
        expect(pcs_gateway_spy).not_to have_received(:get_project)
      end
    end
  end
end
