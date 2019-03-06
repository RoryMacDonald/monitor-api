describe LocalAuthority::UseCase::PcsPopulateReturn do
  let(:use_case) do
    described_class.new(
      get_return: get_return_spy,
      pcs_gateway: pcs_gateway_spy
    )
  end

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
      use_case.execute(id: 1)
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

    context 'existing projects' do
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
                updates: [{
                  dog: 'woof',
                  grantExpenditure: {
                    claimedToDate: [
                      {
                        year: '2017/18',
                        Q1Amount: '111',
                        Q2Amount: '222',
                        Q3Amount: '333',
                        Q4Amount: '444'
                      }
                    ]
                  }
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
                        0
                      ]
                    }
                  },
                  {
                    dateInfo: {
                      period: '2018/19',
                      monthNumber: 12
                    },
                    previousYearPaymentsToDate: 2048,
                    payments: {
                      currentYearPayments: [
                        128,
                        256,
                        512,
                        1024,
                        124,
                        2438,
                        3467,
                        268,
                        3478,
                        278,
                        12,
                        0
                      ]
                    }
                  }
                ]
              end
            )
          end


          it 'Calls the get return use case' do
            use_case.execute(id: 1)
            expect(get_return_spy).to have_received(:execute).with(id: 1)
          end

          context 'unsubmitted' do
            it 'Calls the PCS use case' do
              use_case.execute(id: 1)
              expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: bid_id)
            end

            it 'returns the appropriate data' do
              expect(use_case.execute(id: 3)).to eq(
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
                        SpendToDate: '16092'
                      },
                      grantExpenditure: {
                        claimedToDate: [
                          {
                            year: '2017/18',
                            Q1Amount: '111',
                            Q2Amount: '222',
                            Q3Amount: '333',
                            Q4Amount: '444'
                          },
                          {
                            year: '2018/19',
                            Q1Amount: '903',
                            Q2Amount: '3642',
                            Q3Amount: '7661',
                            Q4Amount: '1826'
                          }
                        ]
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
              use_case.execute(id: 1)
              expect(pcs_gateway_spy).not_to have_received(:get_project)
            end

            it 'returns the appropriate data' do
              expect(use_case.execute(id: 3)).to eq(
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
                  s151GrantClaimApproval: {},
                  grantExpenditure: {
                    claimedToDate: [{
                      year: '1999/2000',
                      Q1Amount: '12',
                      Q2Amount: '14',
                      Q3Amount: '17',
                      Q4Amount: '123'
                    }]
                  }
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

          it 'Calls the get return use case' do
            use_case.execute(id: 3)
            expect(get_return_spy).to have_received(:execute).with(id: 3)
          end

          context 'unsubmitted' do
            it 'Calls the PCS use case' do
              use_case.execute(id: 3)
              expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: bid_id)
            end

            it 'returns the appropriate data' do
              expect(use_case.execute(id: 3)).to eq(
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
                      },
                      grantExpenditure: {
                        claimedToDate: [
                          {
                            year: '1999/2000',
                            Q1Amount: '112',
                            Q2Amount: '128',
                            Q3Amount: '0',
                            Q4Amount: '0'
                          }
                        ]
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
              use_case.execute(id: 3)
              expect(pcs_gateway_spy).not_to have_received(:get_project)
            end

            it 'returns the appropriate data' do
              expect(use_case.execute(id: 3)).to eq(
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
                updates: [{ s151: { claimSummary: { hifTotalFundingRequest: "10000" } } }]
              }
            )
          end

          let(:pcs_gateway_spy) do
            spy(
              get_project: HomesEngland::Domain::PcsBid.new.tap do |project|
                project.project_manager = "Leonard Suskin"
                project.sponsor = "Thomas Suskin"
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
                        0
                      ]
                    }
                  },
                  {
                    dateInfo: {
                      period: '2018/19',
                      monthNumber: 12
                    },
                    previousYearPaymentsToDate: 2048,
                    payments: {
                      currentYearPayments: [
                        128,
                        256,
                        512,
                        1024,
                        124,
                        2438,
                        3467,
                        268,
                        3478,
                        278,
                        12,
                        0
                      ]
                    }
                  }
                ]
              end
            )
          end

          it 'returns the appropriate data' do
            expect(use_case.execute(id: 3)).to eq(
              {
                id: 1,
                bid_id: bid_id,
                type: 'hif',
                project_id: 2,
                status: 'Draft',
                updates: [
                  {
                    s151: {
                      claimSummary: {
                        hifTotalFundingRequest: "10000",
                        hifSpendToDate: '16092'
                      }
                    }
                  }
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
              get_project: HomesEngland::Domain::PcsBid.new.tap do |project|
                project.project_manager = "Robert Howard"
                project.sponsor = "Andrew Anderson"
                project.actuals = [
                  {
                    dateInfo: {
                      period: '2018/19',
                      monthNumber: 12
                    },
                    previousYearPaymentsToDate: 0,
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
            )
          end

          it 'Calls the get return use case' do
            use_case.execute(id: 3)
            expect(get_return_spy).to have_received(:execute).with(id: 3)
          end

          it 'Calls the PCS use case' do
            use_case.execute(id: 3)
            expect(pcs_gateway_spy).to have_received(:get_project).with(bid_id: bid_id)
          end

          it 'returns the appropriate data' do
            expect(use_case.execute(id: 3)).to eq(
              {
                id: 3,
                bid_id: bid_id,
                type: 'hif',
                project_id: 2,
                status: 'Draft',
                updates: [
                  { dog: 'woof' },
                  {
                    dog: 'woof',
                    s151: {
                      claimSummary: {
                        hifSpendToDate: '58'
                      }
                    }
                  }
                ]
              }
            )
          end
        end
      end
    end

    context 'non-existent project' do
      let(:bid_id) { 'AC/MV/65' }
      let(:get_return_spy) do
        spy(
          execute: {
            id: 1,
            bid_id: bid_id,
            type: 'ac',
            project_id: 2,
            status: 'Draft',
            updates: [{
              dog: 'woof',
              grantExpenditure: {
                claimedToDate: [
                  {
                    year: '2017/18',
                    Q1Amount: '111',
                    Q2Amount: '222',
                    Q3Amount: '333',
                    Q4Amount: '444'
                  }
                ]
              }
            }]
          }
        )
      end

      let(:pcs_gateway_spy) do
        spy(
          get_project: nil
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
            updates: [{ dog: 'woof' }]
          }
        )
      end


      it 'Calls the get return use case' do
        use_case.execute(id: 1)
        expect(get_return_spy).to have_received(:execute).with(id: 1)
      end

      it 'Calls the PCS use case' do
        use_case.execute(id: 1)
        expect(pcs_gateway_spy).to have_received(:get_project)
      end

      it 'does not change the data' do
        expect(use_case.execute(id: 1)).to eq(
          {
            id: 1,
            bid_id: bid_id,
            type: 'ac',
            project_id: 2,
            status: 'Draft',
            updates: [{ dog: 'woof' }]
          }
        )
      end
    end
  end
end
