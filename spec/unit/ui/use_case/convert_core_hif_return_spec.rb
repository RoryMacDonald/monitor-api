describe UI::UseCase::ConvertCoreHIFReturn do
  let(:return_to_convert) do
    File.open("#{__dir__}/../../../fixtures/hif_return_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:ui_data_return) do
    File.open("#{__dir__}/../../../fixtures/hif_return_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Converts the project correctly' do
    converted_return = described_class.new.execute(return_data: return_to_convert)

    expect(converted_return).to eq(ui_data_return)
  end

  context 'nil data causing errors' do 
    let(:nil_data_to_convert) do
      {
        fundingProfiles: {
          currentFunding: {}
        },
        widerScheme: [{}],
        outputsForecast: {
          housingStarts: {},
          housingCompletions: {}
        },
        s151Confirmation: {
          hifFunding: {}
        }
      }
    end
  
    let(:returned_empty_return) do
      {
        rmMonthlyCatchup: {
          catchUp: [{}]
        },
        widerScheme: [{
          keyLiveIssues: [{}]
        }],
        fundingProfiles: {
          changeRequired: nil,
          reasonForRequest: nil,
          mitigationInPlace: nil,
          totalHIFGrant: nil,
          projectCashflows: nil
        },
        outputsForecast: {
          housingStarts: {
            anyChanges: nil
          },
          housingCompletions: {
            anyChanges: nil
          }
        },
        s151Confirmation: {
          hifFunding: {
            amendmentConfirmation: nil,
            cashflowConfirmation: nil,
            changesToRequest: {
              hifTotalFundingRequest: nil,
              changesToRequestConfirmation: nil,
              requestedAmount: nil,
              reasonForRequest:nil,
              evidenceOfVariance: nil,
              mitigationInPlace: nil,
              varianceFromBaselinePercent: nil,
              variance: nil
            }
          }
        }
      }
    end
  
    it 'Converts nil data' do
      converted_return = described_class.new.execute(return_data: nil_data_to_convert)
      expect(converted_return).to eq(returned_empty_return)
    end
  end
end
