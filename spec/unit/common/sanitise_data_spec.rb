
describe Common::UseCase::SanitiseData do 
  let(:usecase) { described_class.new }
  let(:response) { usecase.execute(data: data)}

  context 'nulls' do
    context 'simple objects' do
      context 'example 1' do
        let(:data) {{ planning: nil }}
  
        it 'removes the nil value' do
          expect(response).to eq({})
        end
      end

      context 'example 2' do
        let(:data) {{ planning: nil, catsComplete: 'two'}}
  
        it 'removes the nil value' do
          expect(response).to eq({ catsComplete: 'two' })
        end
      end
    end

    context 'nested hashes' do 
      context 'example 1' do
        let(:data) {{ planning: { catsComplete: nil }}}
  
        it 'removes the nil value' do
          expect(response).to eq({ planning: {} })
        end
      end
      
      context 'example 2' do
        let(:data) do 
          {
            planning: {
              catsComplete: nil,
              dogComplete: {
                anotherDog: nil,
                thisDog: nil
              }
            },
            train: nil,
            car: 'broom'
          }
        end
  
        it 'removes the nil value' do
          expect(response).to eq({ car: 'broom', planning: { dogComplete: {}} } )
        end
      end
    end
    
    context 'arrays' do
      context 'example 1' do
        let(:data) { { planning: [{ catsComplete: nil }] } }

        it 'removes the nil values' do
          expect(response).to eq({planning: [{}]})
        end
      end

      context 'example 2' do
        let(:data) { { planning: [{ catsComplete: 'hi', dogComplete: nil }] } }

        it 'removes the nil values' do
          expect(response).to eq({planning: [{catsComplete: 'hi'}]})
        end
      end
    end
  end

  context 'empty strings' do
    context 'example 1' do
      let(:data) do
        {
          fullPlanningStatus: {
            granted: ' ',
            grantedReference: '1234',
            targetSubmission: '  ',
            targetGranted: '2020-04-01',
            summaryOfCriticalPath: ''
          },
          s106: {
            requirement: 'Yes',
            summaryOfRequirement: ''
          },
          statutoryConsents: {
            anyConsents: ' ',
            consents: [
              {
                detailsOfConsent: '',
                targetDateToBeMet: '        '
              }
            ]
          }
        }
      end

      it 'should remove the empty strings' do
        expect(response).to eq(
          {
            fullPlanningStatus: {
              grantedReference: '1234',
              targetGranted: '2020-04-01'
            },
            s106: { requirement: 'Yes' },
            statutoryConsents: {
              consents: [{}]
            }
          }
        )
      end
    end

    context 'example 2' do
      let(:data) do
        {
          myLinks: {
            mhclgProgrammeLinks: [{
              programmes: '',
              description: '    '
            }],
            ogdProgrammeLinks: [{
              programmes: '  ',
              description: 'Build houses underground'
            }],
            otherLinkedGovDepts: [' '],
            description: 'Early development department'
          }
        }
      end

      it 'should remove the empty strings' do
        expect(response).to eq(
          {
            myLinks: {
              mhclgProgrammeLinks: [{}],
              ogdProgrammeLinks: [{
                description: 'Build houses underground'
              }],
              otherLinkedGovDepts: [],
              description: 'Early development department'
            }
          }
        )
      end
    end
  end
end