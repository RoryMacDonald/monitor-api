describe LocalAuthority::UseCase::GetInfrastructures do
  let(:use_case) { described_class.new(find_project: find_project) }

  context 'with a non-FF project' do
    context 'example 1' do
      let(:find_project) do
        spy(execute: {
            type: 'hif',
            data: {
              infrastructures: [
                {
                  information: 'man'
                },
                {
                  information: 'muffin',
                  location: 'arctic'
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

      it 'returns nothing' do
        response = use_case.execute(project_id: 1)
        expect(response).to eq({})
      end
    end

    context 'example 2' do
      let(:find_project) do
        spy(execute: {
            type: 'ac',
            data: {
              infrastructures: [
                {
                  information: 'thunderstorms',
                  otherData: 'weather'
                },
                {
                  information: 'cloud'
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
        use_case.execute(project_id: 6)
        expect(find_project).to have_received(:execute).with(id: 6)
      end

      it 'returns nothing' do
        response = use_case.execute(project_id: 6)
        expect(response).to eq({})
      end
    end
  end

  context 'With an FF project' do
    context 'example 1' do
      let(:data) { {} }
      let(:find_project) do
        spy(execute: 
          {
            type: 'ff',
            data: data
          }
        )
      end

      it 'Calls the find project use case' do
        use_case.execute(project_id: 1)
        expect(find_project).to have_received(:execute).with(id: 1)
      end

      context 'No previous IDs' do 
        let(:data) do 
          {
            infrastructures: {
              HIFFunded: [
                {
                  information: 'man'
                },
                {
                  information: 'muffin',
                  location: 'arctic'
                }
              ],
              widerProject: [
                {
                  biggerinfo: 'tall man'
                },
                {
                  information: 'cake',
                  location: 'north pole'
                }
              ]
            },
            additionalData: {
              data: 'puffin'
            }
          }
        end

        it 'returns the HIF and wider project infrastructures with type and a newly set ID' do
          response = use_case.execute(project_id: 1)
          expect(response[:infrastructures]).to eq({
            HIFFunded:[
              {
                information: 'man',
                type: 'hif',
                id: 1
              },
              {
                information: 'muffin',
                location: 'arctic',
                type: 'hif',
                id: 2
              }
            ],
            widerProject: [
              {
                biggerinfo: 'tall man',
                type: 'wider_project',
                id: 3
              },
              {
                information: 'cake',
                location: 'north pole',
                type: 'wider_project',
                id: 4
              }
            ]
          })
        end
      end

      context 'Already has a saved ID' do
        let(:data) do 
          {
            infrastructures: {
              HIFFunded: [
                {
                  information: 'man',
                  id: 1,
                },
                {
                  information: 'muffin',
                  location: 'arctic',
                  id: 888
                }
              ],
              widerProject: [
                {
                  biggerinfo: 'tall man',
                  id: 4
                },
                {
                  information: 'cake',
                  location: 'north pole',
                  id: 78
                }
              ]
            },
            additionalData: {
              data: 'puffin'
            }
          }
        end

        it 'returns the HIF and wider project infrastructures with type and the previous ID' do
          response = use_case.execute(project_id: 1)
          expect(response[:infrastructures]).to eq({
            HIFFunded: [
                {
                  information: 'man',
                  type: 'hif',
                  id: 1
                },
                {
                  information: 'muffin',
                  location: 'arctic',
                  type: 'hif',
                  id: 888
                }
              ],
              widerProject: [
                {
                  biggerinfo: 'tall man',
                  type: 'wider_project',
                  id: 4
                },
                {
                  information: 'cake',
                  location: 'north pole',
                  type: 'wider_project',
                  id: 78
                }
              ]
            }
          )
        end
      end

    end

    context 'example 2' do
      let(:data) { {} }
      let(:find_project) do
        spy(execute: {
            type: 'ff',
            data: data
          }
        )
      end

      it 'Calls the find project use case' do
        use_case.execute(project_id: 4)
        expect(find_project).to have_received(:execute).with(id: 4)
      end

      context 'with no previous ID' do
        let(:data) do
          {
            infrastructures: {
              HIFFunded: [ 
                {
                  information: 'thunderstorms',
                  otherData: 'weather'
                },
                {
                  information: 'cloud'
                },
                {
                  information: 'snow'
                }
              ],
              widerProject: [
                {
                  info: 'big storm'
                }
              ]
            },
            otherData: {
              contents: 'toucan'
            }
          } 
        end

        it 'returns the infrastructures' do
          response = use_case.execute(project_id: 4)
          expect(response[:infrastructures]).to eq(
            {
              HIFFunded: [
                {
                  information: 'thunderstorms',
                  otherData: 'weather',
                  type: 'hif',
                  id: 1
                },
                {
                  information: 'cloud',
                  type: 'hif',
                  id: 2
                },
                {
                  information: 'snow',
                  type: 'hif',
                  id: 3
                }
              ],
              widerProject: [
                {
                  info: 'big storm',
                  type: 'wider_project',
                  id: 4
                }
              ]
            }
          )
        end
      end

      context 'with a previously saved id' do
        let(:data) do
          {
            infrastructures: {
              HIFFunded: [ 
                {
                  information: 'thunderstorms',
                  otherData: 'weather',
                  id: 34
                },
                {
                  information: 'cloud',
                  id: 6
                },
                {
                  information: 'snow',
                  id: 7
                }
              ],
              widerProject: [
                {
                  info: 'big storm',
                  id: 8
                }
              ]
            },
            otherData: {
              contents: 'toucan'
            }
          } 
        end

        it 'returns the infrastructures' do
          response = use_case.execute(project_id: 4)
          expect(response[:infrastructures]).to eq(
            {
              HIFFunded: [
                {
                  information: 'thunderstorms',
                  otherData: 'weather',
                  type: 'hif',
                  id: 34
                },
                {
                  information: 'cloud',
                  type: 'hif',
                  id: 6
                },
                {
                  information: 'snow',
                  type: 'hif',
                  id: 7
                }
              ],
              widerProject: [
                {
                  info: 'big storm',
                  type: 'wider_project',
                  id: 8
                }
              ]
            }
          )
        end
      end
    end
  end
end
