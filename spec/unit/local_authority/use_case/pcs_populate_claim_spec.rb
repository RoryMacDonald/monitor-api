describe LocalAuthority::UseCase::PcsPopulateClaim do
  let(:pcs_gateway_spy) { nil }

  let(:usecase) do
    described_class.new(
      get_claim_core: get_claim_core_spy,
      pcs_gateway: pcs_gateway_spy
    )
  end

  context 'with PCS disabled' do
    before do
      ENV['PCS'] = nil
    end

    context 'example 1' do
      let(:get_claim_core_spy) do
        spy(
          execute: {
            type: 'hif',
            data: {
              claimKey: "claimValue"
            }
          }
        )
      end

      it 'gets the claim' do
        usecase.execute(claim_id: 15)
        expect(get_claim_core_spy).to have_received(:execute).with(claim_id: 15)
      end

      it 'is inert' do
        response = usecase.execute(claim_id: 15)
        expect(response[:data]).to eq(
          {
            claimKey: "claimValue"
          }
        )
      end
    end

    context 'example 2' do
      let(:get_claim_core_spy) do
        spy(
          execute: {
            type: 'ac',
            data: {
              key: "value"
            }
          }
        )
      end

      it 'gets the claim' do
        usecase.execute(claim_id: 33)
        expect(get_claim_core_spy).to have_received(:execute).with(claim_id: 33)
      end

      it 'is inert' do
        response = usecase.execute(claim_id: 33)
        expect(response[:data]).to eq(
          {
            key: "value"
          }
        )
      end
    end
  end

  context 'with PCS enabled' do
    before do
      ENV['PCS'] = 'Yes'
    end

    after do
      ENV['PCS'] = nil
    end


    let(:pcs_gateway_spy) do
      spy(
        get_project:
        HomesEngland::Domain::PcsBid.new.tap do |project|
          project.project_manager = "Thomas Jenkins"
          project.sponsor = "Toh Kay"
          project.actuals = [
            {
              dateInfo: {
                period: '2018/19',
                monthNumber: 12
              },
              previousYearPaymentsToDate: 12,
              payments: {
                currentYearPayments: [
                  1,
                  2,
                  4,
                  8,
                  16,
                  32,
                  64,
                  128,
                  256,
                  512,
                  1024,
                  2048
                ]
              }
            }
          ]
        end
      )
    end

    context 'example 1' do
      let(:get_claim_core_spy) do
        spy(
          execute: {
            bid_id: 'HIF/MV/151',
            type: 'hif',
            data: {
              claimKey: "claimValue"
            }
          }
        )
      end

      it 'calls the pcs gateway with the bid id' do
        usecase.execute(claim_id: 1)
        expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'HIF/MV/151')
      end
    end

    context 'example 2' do
      let(:get_claim_core_spy) do
        spy(
          execute: {
            bid_id: 'AC/MV/11',
            type: 'hif',
            data: {
              claimKey: "claimValue"
            }
          }
        )
      end

      it 'calls the pcs gateway with the bid id' do
        usecase.execute(claim_id: 11)
        expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'AC/MV/11')
      end
    end
  end
end
