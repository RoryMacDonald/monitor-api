# frozen_string_literal: true

describe UI::UseCase::GetSchemaForReturn do
  describe 'Example 1' do
    let(:schema) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          data: 'some schema dats',
          what_about: 'some cats',
          cats?: 'we like cats'
        }
      end
    end

    let(:in_memory_return_template_spy) { spy(find_by: schema) }
    let(:use_case) { described_class.new(return_template: in_memory_return_template_spy) }
    let(:response) { use_case.execute(type: 'hif') }

    before { response }

    it 'Calls the in memory return template' do
      expect(in_memory_return_template_spy).to have_received(:find_by)
    end

    it 'Calls the in memory return template with the type' do
      expect(in_memory_return_template_spy).to have_received(:find_by).with(type: 'hif')
    end

    it 'Return the schema from in memory return template' do
      expect(response[:schema]).to eq(
        data: 'some schema dats',
        what_about: 'some cats',
        cats?: 'we like cats'
      )
    end
  end

  describe 'Example 2' do
    let(:schema) do
      Common::Domain::Template.new.tap do |p|
        p.schema = {
          houses: 'we like houses',
          buildings: {
            manybuilding: 'cost lots of money'
          }
        }
      end
    end

    let(:in_memory_return_template_spy) { spy(find_by: schema) }
    let(:use_case) { described_class.new(return_template: in_memory_return_template_spy) }
    let(:response) { use_case.execute(type: 'ac') }

    before { response }

    it 'Calls the in memory return template' do
      expect(in_memory_return_template_spy).to have_received(:find_by)
    end

    it 'Calls the in memory return template with the type' do
      expect(in_memory_return_template_spy).to have_received(:find_by).with(type: 'ac')
    end

    it 'Return the schema from in memory return template' do
      expect(response[:schema]).to(
        eq(
          houses: 'we like houses',
          buildings: {
            manybuilding: 'cost lots of money'
          }
        )
      )
    end
  end
end
