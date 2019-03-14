describe UI::UseCase::ConvertUIHIFReturn do
  let(:return_to_convert) do
    File.open("#{__dir__}/../../../fixtures/hif_return_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:core_data_return) do
    File.open("#{__dir__}/../../../fixtures/hif_return_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(return_data: return_to_convert)

    expect(converted_project).to eq(core_data_return)
  end
  
  context 'Converts nil data' do
    let(:nil_data_to_convert) do
      {
        fundingProfiles: {
          fundingRequest: {
            forecast: nil
          },
          currentFunding: {
            forecast: nil
          },
          requestedProfiles: {
            newProfile: nil
          }
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
        fundingProfiles: {
          changeRequired: nil,
          mitigationInPlace: nil,
          reasonForRequest: nil,
          projectCashflows: nil,
          totalHIFGrant: nil
        },
        widerScheme: [{}],
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
            cashflowConfirmation: nil
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
