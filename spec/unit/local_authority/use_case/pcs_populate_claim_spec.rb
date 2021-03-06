describe LocalAuthority::UseCase::PcsPopulateClaim do
  let(:pcs_bid) { nil }
  let(:pcs_gateway_spy) do
    spy(get_project: pcs_bid)
  end

  let(:get_claim_core_spy) do
    spy(
      execute: claim_data
    )
  end

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
      let(:claim_data) do
        {
          type: 'hif',
          data: {
            claimKey: "claimValue"
          }
        }
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
      let(:claim_data) do
        {
          type: 'ac',
          data: {
            key: "value"
          }
        }
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

    context 'submitted' do
      context 'example 1' do
        let(:pcs_bid) { HomesEngland::Domain::PcsBid.new }
        let(:claim_data) do
          {
            bid_id: 'HIF/MV/151',
            status: 'Submitted',
            type: 'hif',
            data: {
              claimKey: "claimValue"
            }
          }
        end

        it 'does not call the pcs gateway' do
          expect(pcs_gateway_spy).not_to have_received(:get_project)
        end

        it 'is inert' do
          expect(usecase.execute(claim_id: 15)).to eq({
            bid_id: 'HIF/MV/151',
            status: 'Submitted',
            type: 'hif',
            data: { claimKey: 'claimValue' }
          })
        end
      end

      context 'example 1' do
        let(:pcs_bid) { HomesEngland::Domain::PcsBid.new }
        let(:claim_data) do
          {
            bid_id: 'AC/MV/11',
            status: 'Submitted',
            type: 'ac',
            data: {
              shouldNotBeChanged: 'is not changed'
            }
          }
        end

        it 'does not call the pcs gateway' do
          expect(pcs_gateway_spy).not_to have_received(:get_project)
        end

        it 'is inert' do
          expect(usecase.execute(claim_id: 15)).to eq({
            bid_id: 'AC/MV/11',
            status: 'Submitted',
            type: 'ac',
            data: {
              shouldNotBeChanged: 'is not changed'
            }
          })
        end
      end
    end

    context 'not found' do
      let(:pcs_bid) { nil }
      context 'example 1' do
        let(:claim_data) do
          {
            bid_id: 'HIF/MV/151',
            type: 'hif',
            data: {
              claimKey: "claimValue"
            }
          }
        end

        it 'gets the claim' do
          usecase.execute(claim_id: 15)
          expect(get_claim_core_spy).to have_received(:execute).with(claim_id: 15)
        end

        it 'calls the pcs gateway with the bid id' do
          usecase.execute(claim_id: 15)
          expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'HIF/MV/151')
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
        let(:claim_data) do
          {
            bid_id: 'AC/MV/15',
            type: 'ac',
            data: {
              key: "value"
            }
          }
        end

        it 'gets the claim' do
          usecase.execute(claim_id: 33)
          expect(get_claim_core_spy).to have_received(:execute).with(claim_id: 33)
        end

        it 'calls the pcs gateway with the bid id' do
          usecase.execute(claim_id: 33)
          expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'AC/MV/15')
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

    context 'hif' do
      context 'example 1' do
        let(:pcs_bid) do
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
        end

        let(:claim_data) do
          {
            id: 1,
            bid_id: 'HIF/MV/151',
            type: 'hif',
            project_id: 2,
            status: 'Draft',
            data: {
              claimSummary: {
                otherData: 'value'
              },
              claimKey: 'claimValue'
            }
          }
        end

        it 'calls the pcs gateway with the bid id' do
          usecase.execute(claim_id: 1)
          expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'HIF/MV/151')
        end

        it 'returns the appropriate data' do
          expect(usecase.execute(claim_id: 1)).to eq({
            id: 1,
            bid_id: 'HIF/MV/151',
            type: 'hif',
            project_id: 2,
            status: 'Draft',
            data: {
              claimSummary: {
                hifSpendToDate: '4107',
                otherData: 'value'
              },
              claimKey: 'claimValue'
            }
          })
        end
      end

      context 'example 2' do
        let(:pcs_bid) do
          HomesEngland::Domain::PcsBid.new.tap do |project|
            project.project_manager = "Thomas Jenkins"
            project.sponsor = "Toh Kay"
            project.actuals = [
              {
                dateInfo: {
                  period: '2018/19',
                  monthNumber: 12
                },
                previousYearPaymentsToDate: 3,
                payments: {
                  currentYearPayments: [
                    1,
                    4,
                    1,
                    5,
                    9,
                    2,
                    6,
                    5,
                    3,
                    5,
                    8,
                    9
                  ]
                }
              }
            ]
          end
        end

        let(:claim_data) do
          {
            id: 3,
            bid_id: 'HIF/MV/11',
            type: 'hif',
            status: 'Draft',
            project_id: 4,
            data: {
              claimKey: "claimValue"
            }
          }
        end

        it 'calls the pcs gateway with the bid id' do
          usecase.execute(claim_id: 3)
          expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'HIF/MV/11')
        end

        it 'returns the appropriate data' do
          expect(usecase.execute(claim_id: 1)).to eq({
            id: 3,
            bid_id: 'HIF/MV/11',
            type: 'hif',
            project_id: 4,
            status: 'Draft',
            data: {
              claimSummary: {hifSpendToDate: '61'},
              claimKey: "claimValue"
            }
          })
        end
      end
    end

    context 'ac' do
      context 'example 1' do
        let(:pcs_bid) do
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
        end

        let(:claim_data) do
          {
            id: 1,
            bid_id: 'AC/MV/151',
            type: 'ac',
            project_id: 2,
            status: 'Draft',
            data: {
              claimKey: 'claimValue',
            }
          }
        end

        it 'calls the pcs gateway with the bid id' do
          usecase.execute(claim_id: 1)
          expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'AC/MV/151')
        end

        it 'returns the appropriate data' do
          expect(usecase.execute(claim_id: 1)).to eq({
            id: 1,
            bid_id: 'AC/MV/151',
            type: 'ac',
            project_id: 2,
            status: 'Draft',
            data: {
              SpendToDate: '4107',
              claimKey: 'claimValue'
            }
          })
        end
      end

      context 'example 2' do
        let(:pcs_bid) do
          HomesEngland::Domain::PcsBid.new.tap do |project|
            project.project_manager = "Thomas Jenkins"
            project.sponsor = "Toh Kay"
            project.actuals = [
              {
                dateInfo: {
                  period: '2018/19',
                  monthNumber: 12
                },
                previousYearPaymentsToDate: 3,
                payments: {
                  currentYearPayments: [
                    1,
                    4,
                    1,
                    5,
                    9,
                    2,
                    6,
                    5,
                    3,
                    5,
                    8,
                    9
                  ]
                }
              }
            ]
          end
        end

        let(:claim_data) do
          {
            id: 3,
            bid_id: 'AC/MV/11',
            type: 'ac',
            status: 'Draft',
            project_id: 4,
            data: {
              claimKey: "claimValue"
            }
          }
        end

        it 'calls the pcs gateway with the bid id' do
          usecase.execute(claim_id: 3)
          expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: 'AC/MV/11')
        end

        it 'returns the appropriate data' do
          expect(usecase.execute(claim_id: 1)).to eq({
            id: 3,
            bid_id: 'AC/MV/11',
            type: 'ac',
            project_id: 4,
            status: 'Draft',
            data: {
              SpendToDate: '61',
              claimKey: "claimValue"
            }
          })
        end
      end
    end
  end
end
