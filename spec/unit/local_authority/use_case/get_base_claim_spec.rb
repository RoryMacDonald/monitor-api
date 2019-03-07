fdescribe LocalAuthority::UseCase::GetBaseClaim do
  let(:claim_gateway) { spy(find_by: schema) }
  let(:project_gateway_spy) { spy(find_by: project) }
  let(:populate_return_spy) { spy(execute: populated_claim) }


  let(:use_case) do
    described_class.new(
      claim_gateway: claim_gateway,
      project_gateway: project_gateway_spy,
      populate_return_template: populate_return_spy
    )
  end
  let(:response) { use_case.execute(project_id: project_id) }

  before { response }

  context 'get the first base claim' do
    context 'example one' do
      let(:schema) do
        Common::Domain::Template.new.tap do |p|
          p.schema = { cats: 'meow' }
        end
      end

      let(:project_id) { 1 }
      let(:data) { { description: 'Super secret project' } }
      let(:project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.type = 'hif'
          p.data = data
        end
      end

      let(:populated_claim) { { populated_data: { cats: 'meow' } } }

      it 'will find the project in the Project Gateway' do
        expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
      end

      it 'will call find_by method on Claim Gateway' do
        expect(claim_gateway).to have_received(:find_by).with(type: project.type)
      end

      xit 'will populate the claim for the project' do
        expect(populate_return_spy).to have_received(:execute).with(schema: schema.schema, data: { baseline_data: project.data })
      end

      xit 'will return a hash with correct id' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(id: project_id)
      end

      xit 'will return a hash with the populated return data' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(data: { cats: 'meow' })
      end

      xit 'will return a hash with correct schema' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(schema: schema.schema)
      end

      xit 'will return a hash with correct number of previous returns' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(no_of_previous_returns: 0)
      end
    end

    context 'example two' do
      let(:schema) do
        Common::Domain::Template.new.tap do |p|
          p.schema = {dogs: 'woof'}
        end
      end

      let(:project_id) { 255 }
      let(:data) { { name: 'Extra secret project' } }
      let(:project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.type = 'hif'
          p.data = data
        end
      end
      let(:populated_claim) { { populated_data: { cows: 'moo' } } }


      it 'will find the project in the Project Gateway' do
        expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
      end

      xit 'will call find_by method on Claim Gateway' do
        expect(claim_gateway).to have_received(:find_by).with(type: project.type)
      end

      xit 'will populate the claim for the project' do
        expect(populate_return_spy).to have_received(:execute).with(schema: schema.schema, data: { baseline_data: project.data })
      end

      xit 'will return a hash with correct id' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(id: project_id)
      end

      xit 'will return a hash with the populated return' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(data: { cows: 'moo' })
      end

      xit 'will return a hash with correct schema' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(schema: schema.schema)
      end

      xit 'will return a hash with correct number of previous returns' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(no_of_previous_returns: 0)
      end
    end
  end

  xcontext 'with previous returns' do
    let(:schema) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {cats: 'meow'}
      end
    end

    let(:data) { { description: 'Super secret project' } }

    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
        p.data = data
      end
    end

    let(:get_returns_spy) do
      spy(execute:
          {
            returns:
            [
              returned_return
            ]
          })
    end

    let(:populated_claim) { { populated_data: { cat: 'Meow' } } }

    context 'example 1' do
      let(:returned_return) do
        {
          id: 0,
          project_id: project_id,
          status: 'Submitted',
          updates: [
            {
              cat: 'Meow'
            }
          ]
        }
      end
      let(:project_id) { 1 }
      it 'executes the get returns use case with the project id' do
        expect(get_returns_spy).to have_received(:execute).with(project_id: 1)
      end

      it 'executes the populate return template use case with data from a return' do
        expect(populate_return_spy).to have_received(:execute).with(
          schema: schema.schema,
          data: {
            baseline_data: project.data,
            return_data: returned_return[:updates][-1]
          }
        )
      end

      it 'returns the number of previous returns' do
        expect(response[:base_claim][:no_of_previous_returns]).to eq(1)
      end

      context 'multiple returns' do
        let(:returned_return) do
          {
            id: 0,
            project_id: project_id,
            status: 'Submitted',
            updates: [
              {
                dog: 'Woof'
              }
            ]
          }
        end

        let(:second_returned_return) do
          {
            id: 1,
            project_id: project_id,
            status: 'Submitted',
            updates: [
              {
                cat: 'Meow'
              }
            ]
          }
        end

        let(:get_returns_spy) do
          spy(execute:
              {
                returns:
                [
                  returned_return,
                  second_returned_return
                ]
              })
        end

        it 'executes the populate return template use case' do
          expect(populate_return_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project.data,
              return_data: second_returned_return[:updates][-1]
            }
          )
        end

        it 'returns the number of previous returns' do
          expect(response[:base_claim][:no_of_previous_returns]).to eq(2)
        end

        context 'multiple updates' do
          let(:second_returned_return) do
            {
              id: 1,
              project_id: project_id,
              status: 'Submitted',
              updates: [
                {
                  bird: 'tweet'
                },
                {
                  alpaca: 'Hum'
                }
              ]
            }
          end
          it 'executes the populate return template use case' do
            expect(populate_return_spy).to have_received(:execute).with(
              schema: schema.schema,
              data: {
                baseline_data: project.data,
                return_data: second_returned_return[:updates][-1]
              }
            )
          end
        end
      end
    end

    context 'example 2' do
      let(:returned_return) do
        {
          id: 0,
          project_id: project_id,
          status: 'Submitted',
          updates: [
            {
              dog: 'Woof'
            }
          ]
        }
      end
      let(:project_id) { 3 }
      it 'executes the get returns use case with the project id' do
        expect(get_returns_spy).to have_received(:execute).with(project_id: 3)
      end

      it 'executes the populate return template use case with data from a return' do
        expect(populate_return_spy).to have_received(:execute).with(
          schema: schema.schema,
          data: {
            baseline_data: project.data,
            return_data: returned_return[:updates][-1]
          }
        )
      end

      it 'returns the number of previous returns' do
        expect(response[:base_claim][:no_of_previous_returns]).to eq(1)
      end

      context 'draft returns' do
        let(:returned_return) do
          {
            id: 0,
            project_id: project_id,
            status: 'Submitted',
            updates: [
              {
                duck: 'Quack'
              }
            ]
          }
        end

        let(:second_returned_return) do
          {
            id: 1,
            project_id: project_id,
            status: 'Draft',
            updates: [
              {
                cow: 'Moo'
              }
            ]
          }
        end

        let(:get_returns_spy) do
          spy(execute:
              {
                returns:
                [
                  returned_return,
                  second_returned_return
                ]
              })
        end

        it 'executes the populate return template use case' do
          expect(populate_return_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project.data,
              return_data: returned_return[:updates][-1]
            }
          )
        end
      end

      context 'multiple returns' do
        let(:returned_return) do
          {
            id: 0,
            project_id: project_id,
            status: 'Submitted',
            updates: [
              {
                duck: 'Quack'
              }
            ]
          }
        end

        let(:second_returned_return) do
          {
            id: 1,
            project_id: project_id,
            status: 'Submitted',
            updates: [
              {
                cow: 'Moo'
              }
            ]
          }
        end

        let(:get_returns_spy) do
          spy(execute:
              {
                returns:
                [
                  returned_return,
                  second_returned_return
                ]
              })
        end

        it 'executes the populate return template use case' do
          expect(populate_return_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project.data,
              return_data: second_returned_return[:updates][-1]
            }
          )
        end

        it 'returns the number of previous returns' do
          expect(response[:base_claim][:no_of_previous_returns]).to eq(2)
        end

        context 'multiple updates' do
          let(:second_returned_return) do
            {
              id: 1,
              project_id: project_id,
              status: 'Submitted',
              updates: [
                {
                  guppy: 'Pop'
                },
                {
                  llama: 'Buzz'
                }
              ]
            }
          end
          it 'executes the populate return template use case' do
            expect(populate_return_spy).to have_received(:execute).with(
              schema: schema.schema,
              data: {
                baseline_data: project.data,
                return_data: second_returned_return[:updates][-1]
              }
            )
          end
        end
      end
    end
  end
end
