describe HomesEngland::UseCase::GetProjectOverview, focus: true do
  let(:find_project_spy) { spy(execute: found_project) }
  let(:claim_gateway_spy) { spy(get_all: found_claims) }
  let(:return_gateway_spy) { spy(get_returns: found_returns) }
  let(:baseline_gateway_spy) { spy(versions_for: found_baselines) }

  let(:use_case) do
    described_class.new(
      baseline_gateway: baseline_gateway_spy,
      claim_gateway: claim_gateway_spy,
      find_project: find_project_spy,
      return_gateway: return_gateway_spy
    )
  end

  let(:response) { use_case.execute(id: project_id) }

  before { response }

  shared_examples 'the project overview use case' do
    it 'Gets the project from the gateway' do
      expect(find_project_spy).to(
        have_received(:execute).with(id: project_id)
      )
    end

    it 'Gets the claims for the project' do
      expect(claim_gateway_spy).to(
        have_received(:get_all).with(project_id: project_id)
      )
    end

    it 'Gets the returns for the project' do
      expect(return_gateway_spy).to(
        have_received(:get_returns).with(project_id: project_id)
      )
    end

    it 'Gets the baselines for the project' do
      expect(baseline_gateway_spy).to(
        have_received(:versions_for).with(project_id: project_id)
      )
    end

    it 'Returns the project name' do
      expect(response[:name]).to eq(expected_project_name)
    end

    it 'Returns the project status' do
      expect(response[:status]).to eq(expected_project_status)
    end

    it 'Returns the project data' do
      expect(response[:data]).to eq(expected_project_data)
    end

    it 'Returns the return information for the project' do
      expect(response[:returns]).to eq(expected_return_information)
    end

    it 'Returns the claim information for the project' do
      expect(response[:claims]).to eq(expected_claim_information)
    end

    it 'Returns the baseline information for the project' do
      expect(response[:baselines]).to eq(expected_baseline_information)
    end
  end

  context 'Example one' do
    let(:found_project) do
      {
        name: 'Meow',
        status: 'Draft',
        data: {
          this_is: 'Some data'
        }
      }
    end

    let(:found_claims) do
      [
        LocalAuthority::Domain::Claim.new.tap do |r|
          r.id = 202
          r.status = 'Submitted'
        end
      ]
    end

    let(:found_returns) do
      [
        LocalAuthority::Domain::Return.new.tap do |r|
          r.id = 101
          r.status = 'Draft'
        end
      ]
    end

    let(:found_baselines) do
      [
        HomesEngland::Domain::Baseline.new.tap do |b|
          b.id = 303
          b.status = 'Draft'
        end
      ]
    end

    it_behaves_like 'the project overview use case'

    let(:project_id) { 10 }
    let(:expected_project_name) { 'Meow' }
    let(:expected_project_status) { 'Draft' }
    let(:expected_project_data) { { this_is: 'Some data' } }

    let(:expected_return_information) do
      [
        {
          id: 101,
          status: 'Draft'
        }
      ]
    end

    let(:expected_claim_information) do
      [
        {
          id: 202,
          status: 'Submitted'
        }
      ]
    end

    let(:expected_baseline_information) do
      [
        {
          id: 303,
          status: 'Draft'
        }
      ]
    end
  end

  context 'Example two' do
    let(:found_project) do
      {
        name: 'Woof',
        status: 'Submitted',
        data: {
          this_is: 'More data'
        }
      }
    end

    let(:found_returns) do
      [
        LocalAuthority::Domain::Return.new.tap do |r|
          r.id = 111
          r.status = 'Submitted'
        end,
        LocalAuthority::Domain::Return.new.tap do |r|
          r.id = 112
          r.status = 'Draft'
        end
      ]
    end

    let(:found_claims) do
      [
        LocalAuthority::Domain::Claim.new.tap do |r|
          r.id = 222
          r.status = 'Draft'
        end,
        LocalAuthority::Domain::Claim.new.tap do |r|
          r.id = 223
          r.status = 'Draft'
        end
      ]
    end

    let(:found_baselines) do
      [
        HomesEngland::Domain::Baseline.new.tap do |b|
          b.id = 333
          b.status = 'Submitted'
        end,
        HomesEngland::Domain::Baseline.new.tap do |b|
          b.id = 334
          b.status = 'Draft'
        end
      ]
    end

    it_behaves_like 'the project overview use case'

    let(:project_id) { 20 }
    let(:expected_project_name) { 'Woof' }
    let(:expected_project_status) { 'Submitted' }
    let(:expected_project_data) { { this_is: 'More data' } }

    let(:expected_return_information) do
      [
        {
          id: 111,
          status: 'Submitted'
        },
        {
          id: 112,
          status: 'Draft'
        }
      ]
    end

    let(:expected_claim_information) do
      [
        {
          id: 222,
          status: 'Draft'
        },
        {
          id: 223,
          status: 'Draft'
        }
      ]
    end

    let(:expected_baseline_information) do
      [
        {
          id: 333,
          status: 'Submitted'
        },
        {
          id: 334,
          status: 'Draft'
        }
      ]
    end
  end
end
