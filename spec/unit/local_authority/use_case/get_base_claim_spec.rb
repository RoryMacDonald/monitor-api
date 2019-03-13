describe LocalAuthority::UseCase::GetBaseClaim do
  let(:claim_gateway) { spy(find_by: schema) }
  let(:find_project_spy) { spy(execute: project) }
  let(:populate_claim_spy) { spy(execute: populated_claim) }


  let(:use_case) do
    described_class.new(
      claim_gateway: claim_gateway,
      find_project: find_project_spy,
      populate_return_template: populate_claim_spy,
      get_claims: get_claims_spy 
    )
  end
  let(:response) { use_case.execute(project_id: project_id) }

  before { response }

  context 'get the first base claim' do
    let(:get_claims_spy) do
      spy(execute:
        { claims: [] }
      )
    end

    context 'example one' do
      let(:schema) do
        Common::Domain::Template.new.tap do |p|
          p.schema = { cats: 'meow' }
        end
      end

      let(:project_id) { 1 }
      let(:data) { { description: 'Super secret project' } }
      let(:project) do
        {
          type: 'hif',
          data: data
        }
      end

      let(:populated_claim) { { populated_data: { cats: 'meow' } } }

      it 'will find the project in the Project Gateway' do
        expect(find_project_spy).to have_received(:execute).with(id: project_id)
      end

      it 'will call find_by method on Claim Gateway' do
        expect(claim_gateway).to have_received(:find_by).with(type: project[:type])
      end

      it 'will populate the claim for the project' do
        expect(populate_claim_spy).to have_received(:execute).with(schema: schema.schema, data: { baseline_data: project[:data] })
      end

      it 'will return a hash with correct id' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(id: project_id)
      end

      it 'will return a hash with the populated return data' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(data: { cats: 'meow' })
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
        {
          type: 'ac',
          data: data
        }
      end
      let(:populated_claim) { { populated_data: { cows: 'moo' } } }


      it 'will find the project in the Project Gateway' do
        expect(find_project_spy).to have_received(:execute).with(id: project_id)
      end

      it 'will call find_by method on Claim Gateway' do
        expect(claim_gateway).to have_received(:find_by).with(type: project[:type])
      end

      it 'will populate the claim for the project' do
        expect(populate_claim_spy).to have_received(:execute).with(schema: schema.schema, data: { baseline_data: project[:data] })
      end

      it 'will return a hash with correct id' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(id: project_id)
      end

      it 'will return a hash with the populated return' do
        expect(use_case.execute(project_id: project_id)[:base_claim]).to include(data: { cows: 'moo' })
      end
    end
  end

  context 'with previous claims' do
    let(:schema) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {cats: 'meow'}
      end
    end

    let(:data) { { description: 'Super secret project' } }

    let(:project) do
      {
        type: 'hif',
        data: data
      }
    end

    let(:get_claims_spy) do
      spy(execute:
          {
            claims:
            [
              last_claim
            ]
          }
        )
    end

    let(:populated_claim) { { populated_data: { cat: 'Meow' } } }

    context 'example 1' do
      let(:last_claim) do
        {
          id: 2,
          project_id: project_id,
          status: 'Submitted',
          data: {
            cat: 'Meow'
          }
        }
      end

      let(:project_id) { 1 }

      it 'executes the get claims use case with the project id' do
        expect(get_claims_spy).to have_received(:execute).with(project_id: 1)
      end

      it 'executes the populate return template use case with data from the last claim' do
        expect(populate_claim_spy).to have_received(:execute).with(
          schema: schema.schema,
          data: {
            baseline_data: project[:data],
            claim_data: last_claim[:data]
          }
        )
      end

      context 'multiple claims' do
        let(:first_claim) do
          {
            id: 1,
            project_id: project_id,
            status: 'Submitted',
            data: {
              dog: 'Woof'
            }
          }
        end

        let(:last_claim) do
          {
            id: 6,
            project_id: project_id,
            status: 'Submitted',
            data: {
              cat: 'Meow'
            }
          }
        end

        let(:get_claims_spy) do
          spy(execute:
              {
                claims:
                [
                  first_claim,
                  last_claim
                ]
              }
            )
        end

        it 'executes the populate return template use case' do
          expect(populate_claim_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project[:data],
              claim_data: last_claim[:data]
            }
          )
        end
      end

      context 'only draft claims' do
        let(:unsubmitted_claim) do
          {
            id: 1,
            project_id: project_id,
            status: 'Draft',
            data: {
              cow: 'Moo'
            }
          }
        end
  
        let(:get_claims_spy) do
          spy(execute:
              {
                claims:
                [
                  unsubmitted_claim
                ]
              }
            )
        end

        it 'executes the populate return template use case' do
          expect(populate_claim_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project.data,
            }
          )
        end
      end
    end

    context 'example 2' do
      let(:last_claim) do
        {
          id: 0,
          project_id: project_id,
          status: 'Submitted',
          data: {
            dog: 'Woof'
          }
        }
      end
      let(:project_id) { 3 }

      it 'executes the get claims use case with the project id' do
        expect(get_claims_spy).to have_received(:execute).with(project_id: 3)
      end

      it 'executes the populate return template use case with data from a claim' do
        expect(populate_claim_spy).to have_received(:execute).with(
          schema: schema.schema,
          data: {
            baseline_data: project[:data],
            claim_data: last_claim[:data]
          }
        )
      end

      context 'draft claims' do
        let(:last_submitted_claim) do
          {
            id: 0,
            project_id: project_id,
            status: 'Submitted',
            data: {
              duck: 'Quack'
            }
          }
        end

        let(:unsubmitted_claim) do
          {
            id: 1,
            project_id: project_id,
            status: 'Draft',
            data: {
              cow: 'Moo'
            }
          }
        end

        let(:get_claims_spy) do
          spy(execute:
              {
                claims:
                [
                  last_submitted_claim,
                  unsubmitted_claim
                ]
              }
            )
        end

        it 'executes the populate return template use case' do
          expect(populate_claim_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project[:data],
              claim_data: last_submitted_claim[:data]
            }
          )
        end
      end

      context 'multiple claims' do
        let(:first_claim) do
          {
            id: 0,
            project_id: project_id,
            status: 'Submitted',
            data: {
              duck: 'Quack'
            }
          }
        end

        let(:last_claim) do
          {
            id: 1,
            project_id: project_id,
            status: 'Submitted',
            data: {
              cow: 'Moo'
            }
          }
        end

        let(:get_claims_spy) do
          spy(execute:
              {
                claims:
                [
                  first_claim,
                  last_claim
                ]
              })
        end

        it 'executes the populate return template use case' do
          expect(populate_claim_spy).to have_received(:execute).with(
            schema: schema.schema,
            data: {
              baseline_data: project[:data],
              claim_data: last_claim[:data]
            }
          )
        end
      end
    end
  end
end
