describe UI::Builder::Template do
  describe 'Example one' do
    let(:builder) do
      described_class.new(
        title: 'Example one',
        path: "#{__dir__}/fixtures/example_one"
      )
    end

    let(:template) { builder.build }

    it 'Has the title in the schema' do
      expect(template.schema[:title]).to eq('Example one')
    end

    it 'Adds shared data to the schema sharedData' do
      builder.add_shared_data(file_name: 'copy.json')

      expected_shared_data_one = {
        from: ['one', 'two'],
        to: ['three', 'four']
      }

      expected_shared_data_two = {
        from: ['five', 'six'],
        to: ['seven', 'eight']
      }

      expect(template.schema[:sharedData][0]).to eq(expected_shared_data_one)
      expect(template.schema[:sharedData][1]).to eq(expected_shared_data_two)
      expect(template.schema[:sharedData]).to eq([expected_shared_data_one, expected_shared_data_two])
    end

    it 'Adds the section to the schema properties' do
      builder.add_section(section_name: :sectionOne, file_name: 'section_one.json')
      builder.add_section(section_name: :sectionTwo, file_name: 'section_two.json')

      expected_section_one = { section: 'one', anotherSection: 'two' }
      expected_section_two = { cat: 'meow', dog: 'woof' }

      expect(template.schema[:properties][:sectionOne]).to eq(expected_section_one)
      expect(template.schema[:properties][:sectionTwo]).to eq(expected_section_two)
    end
  end

  describe 'Example two' do
    let(:builder) do
      described_class.new(
        title: 'Example two',
        path: "#{__dir__}/fixtures/example_two"
      )
    end

    let(:template) { builder.build }

    it 'Has the title in the schema' do
      expect(template.schema[:title]).to eq('Example two')
    end

    it 'Adds shared data to the schema sharedData' do
      builder.add_shared_data(file_name: 'copy.json')

      expected_shared_data_one = {
        from: ['a', 'b'],
        to: ['c', 'd']
      }

      expected_shared_data_two = {
        from: ['e', 'f'],
        to: ['g', 'h']
      }

      expected_shared_data_three = {
        from: ['i', 'j'],
        to: ['k', 'l']
      }

      expect(template.schema[:sharedData][0]).to eq(expected_shared_data_one)
      expect(template.schema[:sharedData][1]).to eq(expected_shared_data_two)
      expect(template.schema[:sharedData][2]).to eq(expected_shared_data_three)
      expect(template.schema[:sharedData]).to eq([expected_shared_data_one, expected_shared_data_two, expected_shared_data_three])
    end

    it 'Adds the section to the schema properties' do
      builder.add_section(section_name: :cats, file_name: 'cats.json')
      builder.add_section(section_name: :dogs, file_name: 'dogs.json')

      expected_section_one = { noise: 'meow', softness: 'very' }
      expected_section_two = { noise: 'woof', goodBoy: 'yes' }

      expect(template.schema[:properties][:cats]).to eq(expected_section_one)
      expect(template.schema[:properties][:dogs]).to eq(expected_section_two)
    end
  end
end
