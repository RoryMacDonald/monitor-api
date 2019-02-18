# frozen_string_literal: true

describe UI::UseCase::GetBaseReturn do
  context 'Example one' do
    let(:convert_core_return_spy) { spy(execute: { cow: 'moo' }) }
    let(:get_base_return_spy) { spy(execute: { base_return: { id: 3, data: { cat: 'meow' }, schema: { schema: 'schema' }, no_of_previous_returns: 12 } }) }
    let(:template) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          my_new_schema: 'cats'
        }
      end
    end
    let(:in_memory_return_schema_spy) { spy( find_by: template)}
    let(:use_case) do
      described_class.new(
        get_base_return: get_base_return_spy,
        return_schema: in_memory_return_schema_spy,
        find_project: find_project_spy,
        convert_core_return: convert_core_return_spy
      )
    end
    let(:response) { use_case.execute(project_id: 4) }
    let(:find_project_spy) { spy(execute: { type: 'nothif' }) }

    before { response }

    it 'Calls execute on the get base return usecase' do
      expect(get_base_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to get base return' do
      expect(get_base_return_spy).to have_received(:execute).with(project_id: 4)
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 4)
    end

    it 'Call the schema gateway' do
      expect(in_memory_return_schema_spy).to have_received(:find_by).with(type: 'nothif')
    end

    it 'Calls the convert core return use case with the data' do
      expect(convert_core_return_spy).to have_received(:execute).with(return_data: { cat: 'meow' }, type: 'nothif')
    end

    it 'returns converted data' do
      expect(response).to eq(base_return: { id: 3, data: { cow: 'moo' }, schema: { my_new_schema: 'cats' }, no_of_previous_returns: 12 })
    end

  end

  context 'Example two' do
    let(:find_project_spy) { spy(execute: { type: 'somethingelse' }) }
    let(:convert_core_return_spy) { spy(execute: { ducks: 'quack' }) }
    let(:get_base_return_spy) { spy(execute: { base_return: { id: 'woof', schema: { dog: 'woof' }, data: { cats: 'meow' } } }) }
    let(:template) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          another_schema: 'dogs'
        }
      end
    end
    let(:in_memory_return_schema_spy) { spy( find_by: template)}
    let(:use_case) do
      described_class.new(
        get_base_return: get_base_return_spy,
        return_schema: in_memory_return_schema_spy,
        find_project: find_project_spy,
        convert_core_return: convert_core_return_spy
      )
    end
    let(:response) { use_case.execute(project_id: 7) }

    before { response }

    it 'Calls execute on the get base return usecase' do
      expect(get_base_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to get base return' do
      expect(get_base_return_spy).to have_received(:execute).with(project_id: 7)
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    it 'Call the schema gateway' do
      expect(in_memory_return_schema_spy).to have_received(:find_by).with(type: 'somethingelse')
    end

    it 'Calls the convert core return use case with the data' do
      expect(convert_core_return_spy).to have_received(:execute).with(return_data: { cats: 'meow' }, type: 'somethingelse')
    end

    it 'returns converted data' do
      expect(response).to eq(base_return: { id: 'woof', schema: { another_schema: 'dogs' }, data: { ducks: 'quack' } })
    end
  end
end
