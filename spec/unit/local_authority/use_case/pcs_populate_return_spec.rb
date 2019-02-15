describe LocalAuthority::UseCase::PcsPopulateReturn do
  context 'with PCS disabled' do
    before do
      ENV['PCS'] = nil
    end

    let(:bid_id) { 'AC/MV/65' }

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

    let(:get_return_spy) do
      spy(
        execute: {
          id: 1,
          bid_id: bid_id,
          type: 'ac',
          project_id: 2,
          status: 'Draft',
          updates: [{ dog: 'woof' }, { dog: 'woof' }]
        }
      )
    end

    it 'Does not call the PCS use case' do
      use_case.execute(id: 1, api_key: 'M.V.C')
      expect(pcs_gateway_spy).not_to have_received(:get_project)
    end
  end

  context 'With PCS enabled' do
    before do
      ENV['PCS'] = 'yes'
    end

    after do
      ENV['PCS'] = nil
    end

    context 'ac projects' do
      context 'example 1' do
        let(:bid_id) { 'AC/MV/65' }
        let(:get_return_spy) do
          spy(
            execute: {
              id: 1,
              bid_id: bid_id,
              type: 'ac',
              project_id: 2,
              status: 'Draft',
              updates: [{ dog: 'woof' }]
            }
          )
        end

        let(:pcs_gateway_spy) do
          spy(
            get_project: HomesEngland::Domain::PcsBid.new.tap do |project|
              project.project_manager = "Thomas Jenkins"
              project.sponsor = "Toh Kay"
              project.actuals = [
                {
                  dateInfo: {
                    period: '2004/5'
                  },
                  previousYearPaymentsToDate: 2048,
                  payments: {
                    currentYearPayments: [
                      1,
                      2,
                      4,
                      8
                    ]
                  }
                },
                {
                  dateInfo: {
                    period: '2005/6'
                  },
                  payments: {
                    currentYearPayments: [
                      128,
                      256,
                      512,
                      1024
                    ]
                  }
                }
              ]
            end
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

          it 'returns the appropriate data' do
            expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
              {
                id: 1,
                bid_id: bid_id,
                type: 'ac',
                project_id: 2,
                status: 'Draft',
                updates: [
                  {
                    dog: 'woof',
                    s151GrantClaimApproval: {
                      SpendToDate: '3983'
                    }
                  }
                ]
              }
            )
          end
        end

        context 'submitted' do
          let(:get_return_spy) do
            spy(
              execute: {
                id: 1,
                bid_id: bid_id,
                type: 'ac',
                project_id: 2,
                status: 'Submitted',
                updates: [{ dog: 'woof' }]
              }
            )
          end

          it 'Does not call the PCS use case' do
            use_case.execute(id: 1, api_key: 'M.V.C')
            expect(pcs_gateway_spy).not_to have_received(:get_project)
          end

          it 'returns the appropriate data' do
            expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
              {
                id: 1,
                bid_id: bid_id,
                type: 'ac',
                project_id: 2,
                status: 'Submitted',
                updates: [{ dog: 'woof' }]
              }
            )
          end
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
              updates: [{ dog: 'woof' }, {
                dog: 'woof',
                s151GrantClaimApproval: {}
              }]
            }
          )
        end

        let(:pcs_gateway_spy) do
          spy(
            get_project: HomesEngland::Domain::PcsBid.new.tap do |project|
              project.project_manager = "Thomas Jenkins"
              project.sponsor = "Toh Kay"
              project.actuals = [
                {
                  dateInfo: {
                    period: '1999/2000'
                  },
                  previousYearPaymentsToDate: 256,
                  payments: {
                    currentYearPayments: [
                      16,
                      32,
                      64,
                      128
                    ]
                  }
                }
              ]
            end
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

        context 'unsubmitted' do
          it 'Calls the PCS use case' do
            use_case.execute(id: 3, api_key: 'M.R.W')
            expect(pcs_gateway_spy).to have_received(:get_project).with(api_key: 'M.R.W', bid_id: bid_id)
          end

          it 'returns the appropriate data' do
            expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
              {
                id: 3,
                bid_id: bid_id,
                type: 'ac',
                project_id: 2,
                status: 'Draft',
                updates: [
                  { dog: 'woof' },
                  {
                    dog: 'woof',
                    s151GrantClaimApproval: {
                      SpendToDate: '496'
                    }
                  }
                ]
              }
            )
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
                updates: [{ dog: 'woof' }, {
                  dog: 'woof',
                  s151GrantClaimApproval: {}
                }]
              }
            )
          end

          it 'Does not call the PCS use case' do
            use_case.execute(id: 3, api_key: 'M.R.W')
            expect(pcs_gateway_spy).not_to have_received(:get_project)
          end

          it 'returns the appropriate data' do
            expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
              {
                id: 3,
                bid_id: bid_id,
                type: 'ac',
                project_id: 2,
                status: 'Submitted',
                updates: [
                  { dog: 'woof' },
                  {
                    dog: 'woof',
                    s151GrantClaimApproval: {}
                  }
                ]
              }
            )
          end
        end
      end
    end

    context 'hif projects' do
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
              updates: [{ dog: 'woof' }]
            }
          )
        end

        let(:pcs_gateway_spy) do
          spy(
            get_project: HomesEngland::Domain::PcsBid.new
          )
        end

        let(:use_case) do
          described_class.new(
            get_return: get_return_spy,
            pcs_gateway: pcs_gateway_spy
          )
        end

        it 'returns the appropriate data' do
          expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
            {
              id: 1,
              bid_id: bid_id,
              type: 'hif',
              project_id: 2,
              status: 'Draft',
              updates: [
                { dog: 'woof' }
              ]
            }
          )
        end
      end

      context 'example 2' do
        let(:bid_id) { 'HIF/MV/11' }
        let(:get_return_spy) do
          spy(
            execute: {
              id: 3,
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
            get_project: HomesEngland::Domain::PcsBid.new
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

        it 'Calls the PCS use case' do
          use_case.execute(id: 3, api_key: 'M.R.W')
          expect(pcs_gateway_spy).to have_received(:get_project).with(api_key: 'M.R.W', bid_id: bid_id)
        end

        it 'returns the appropriate data' do
          expect(use_case.execute(id: 3, api_key: 'M.R.W')).to eq(
            {
              id: 3,
              bid_id: bid_id,
              type: 'hif',
              project_id: 2,
              status: 'Draft',
              updates: [
                { dog: 'woof' },
                { dog: 'woof' }
              ]
            }
          )
        end
      end
    end
  end
end
