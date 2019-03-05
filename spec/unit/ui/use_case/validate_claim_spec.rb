describe UI::UseCase::ValidateClaim do
  let(:schema) { spy() }
  let(:template) { spy(schema: schema, invalid_paths: invalid_paths) }
  let(:claim_template) do
    spy(find_by: template)
  end
  let(:get_claim_path_titles) { spy(execute: { path_titles: path_titles}) }
  let(:usecase) do
    described_class.new(
      claim_template: claim_template,
      get_claim_path_titles: get_claim_path_titles
    )
  end
  let(:get_claim_path_titles) do
    Class.new do
      def initialize(path_titles)
        @path_titles = path_titles
      end

      def execute(*)
        path_titles = @path_titles.shift
        { path_titles: path_titles }
      end
    end.new(path_titles)
  end

  context 'invalid' do
    context 'example 1' do
      let(:path_titles) { [["First", "Second"]] }
      let(:invalid_paths) { [[:first_node, :second_node]] }

      it 'calls the get schema gateway' do
        usecase.execute(type: 'hif', claim_data: {})
        expect(claim_template).to have_received(:find_by).with(type: 'hif')
      end
      it 'gets the invalid paths' do
        usecase.execute(type: 'hif', claim_data: { my_data: 'my value' })
        expect(template).to have_received(:schema)
        expect(template).to have_received(:invalid_paths).with({ my_data: 'my value' })
      end

      it 'calls get pretty paths' do
        expect(get_claim_path_titles).to receive(:execute).with(
          path: [:first_node, :second_node],
          schema: schema
        ).and_call_original
        usecase.execute(type: 'hif', claim_data: { my_data: 'my value' })
      end

      it 'returns the appropriate data' do
        response = usecase.execute(type: 'ac', claim_data: {})
        expect(response).to eq(
          {
            valid: false,
            invalid_paths: [[:first_node, :second_node]],
            invalid_pretty_paths: [["First", "Second"]]
          }
        )
      end
    end

    context 'example 2' do
      let(:path_titles) { [["A", "Array of A"], ["B", "Array of B"]] }
      let(:invalid_paths) { [[:a_node, 0], [:first_node, 1]] }

      it 'calls the get schema gateway' do
        usecase.execute(type: 'ac', claim_data: {})
        expect(claim_template).to have_received(:find_by).with(type: 'ac')
      end

      it 'gets the invalid paths' do
        usecase.execute(type: 'ac', claim_data: {})
        expect(template).to have_received(:schema)
        expect(template).to have_received(:invalid_paths).with({})
      end

      it 'calls get pretty paths' do
        expect(get_claim_path_titles).to receive(:execute).with(
          path: [:a_node, 0],
          schema: schema
        ).and_call_original

        expect(get_claim_path_titles).to receive(:execute).with(
          path: [:first_node, 1],
          schema: schema
        ).and_call_original

        usecase.execute(type: 'ac', claim_data: {})
      end

      it 'returns the appropriate data' do
        response = usecase.execute(type: 'ac', claim_data: {})
        expect(response).to eq(
          {
            valid: false,
            invalid_paths: [[:a_node, 0], [:first_node, 1]],
            invalid_pretty_paths: [["A", "Array of A"], ["B", "Array of B"]]
          }
        )
      end
    end
  end

  context 'valid' do
    let(:path_titles) { [] }
    let(:invalid_paths) { [] }

    it 'returns the appropriate results' do
      response = usecase.execute(type: 'ac', claim_data: { claimSummary: {} })
      expect(response).to eq(
        {
          valid: true,
          invalid_paths: [],
          invalid_pretty_paths: []
        }
      )
    end
  end
end
