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
