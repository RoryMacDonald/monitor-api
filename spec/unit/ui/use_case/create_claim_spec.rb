describe UI::UseCase::CreateClaim do
  context 'example 1' do
    let(:find_project_spy) { spy(execute: { type: 'hif' }) }
    let(:create_claim_spy) { spy(execute: { claim_id: 1 }) }
    let(:convert_ui_claim_spy) { spy(execute: { Cows: 'moo' }) }
    let(:use_case) do
      described_class.new(
        create_claim_core: create_claim_spy,
        convert_ui_claim: convert_ui_claim_spy,
        find_project: find_project_spy
      )
    end

    it 'Calls find project' do
      use_case.execute(project_id: 1, claim_data: { Duck: 'Quack' })
      expect(find_project_spy).to have_received(:execute).with(id: 1)
    end

    it 'Calls convert ui claim' do
      use_case.execute(project_id: 1, claim_data: { Duck: 'Quack' })
      expect(convert_ui_claim_spy).to have_received(:execute).with(
        claim_data: { Duck: 'Quack' },
        type: 'hif'
      )
    end

    it 'Calls create claim core' do
      use_case.execute(project_id: 1, claim_data: { Duck: 'Quack' })
      expect(create_claim_spy).to have_received(:execute).with(
        project_id: 1,
        claim_data: { Cows: 'moo' }
      )
    end

    it 'Returns the id of the created claim' do
      response = use_case.execute(project_id: 1, claim_data: { Duck: 'Quack' })
      expect(response[:claim_id]).to eq(1)
    end
  end

  context 'example 2' do
    let(:find_project_spy) { spy(execute: { type: 'ac' }) }
    let(:create_claim_spy) { spy(execute: { claim_id: 3 }) }
    let(:convert_ui_claim_spy) { spy(execute: { dog: 'shibe' }) }
    let(:use_case) do
      described_class.new(
        create_claim_core: create_claim_spy,
        convert_ui_claim: convert_ui_claim_spy,
        find_project: find_project_spy
      )
    end

    it 'Calls find project' do
      use_case.execute(project_id: 6, claim_data: { Dog: 'Woof' })
      expect(find_project_spy).to have_received(:execute).with(id: 6)
    end

    it 'Calls convert ui claim' do
      use_case.execute(project_id: 6, claim_data: { Dog: 'Woof' })
      expect(convert_ui_claim_spy).to have_received(:execute).with(
        claim_data: { Dog: 'Woof' },
        type: 'ac'
      )
    end

    it 'Calls create claim core' do
      use_case.execute(project_id: 6, claim_data: { Dog: 'Woof' })
      expect(create_claim_spy).to have_received(:execute).with(
        project_id: 6,
        claim_data: { dog: 'shibe' }
      )
    end

    it 'Returns the id of the created claim' do
      response = use_case.execute(project_id: 3, claim_data: { Dog: 'Woof' })
      expect(response[:claim_id]).to eq(3)
    end
  end
end
