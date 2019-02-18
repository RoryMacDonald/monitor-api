describe LocalAuthority::UseCase::GetInfrastructures do
  let(:use_case) { described_class.new(find_project: find_project) }

  context 'example 1' do
    let(:find_project) do
      spy(execute: {
          data: {
            infrastructures: [
              {
                information: 'man',
                notNeeded: 'cold'
              },
              {
                information: 'muffin'
              }
            ],
            additionalData: {
              data: 'puffin'
            }
          }
        }
      )
    end

    it 'Calls the find project use case' do
      use_case.execute(project_id: 1)
      expect(find_project).to have_received(:execute).with(id: 1)
    end

    it 'returns the infrastructures' do
      response = use_case.execute(project_id: 1)
      expect(response[:infrastructures]).to eq(
        [
          {
            information: 'man'
          },
          {
            information: 'muffin'
          }
        ]
      )
    end
  end

  context 'example 2' do
    let(:find_project) do
      spy(execute: {
          data: {
            infrastructures: [
              {
                information: 'thunderstorms',
                unnecessaryInfo: 'not needed'
              },
              {
                information: 'cloud',
                moreUnnecessaryInfo: 'not needed'
              },
              {
                information: 'snow'
              }
            ],
            otherData: {
              contents: 'toucan'
            }
          }
        }
      )
    end

    it 'Calls the find project use case' do
      use_case.execute(project_id: 4)
      expect(find_project).to have_received(:execute).with(id: 4)
    end

    it 'returns the infrastructures' do
      response = use_case.execute(project_id: 4)
      expect(response[:infrastructures]).to eq(
        [
          {
            information: 'thunderstorms'
          },
          {
            information: 'cloud'
          },
          {
            information: 'snow'
          }
        ]
      )
    end
  end
end
