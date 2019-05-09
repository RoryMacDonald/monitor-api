describe LocalAuthority::UseCase::FindPathData do

  let(:use_case) do
    described_class.new.execute(
      data: baseline_data,
      path: path
    )
  end

  context 'with simple paths' do
    context 'example 1' do
      let(:baseline_data) do
        { noises: { cat: 'meow' } }
      end

      let(:path) { [:noises, :cat] }
      it 'can find a simple path' do
        expect(use_case).to eq(found: 'meow')
      end
    end

    context 'example 2' do
      let(:baseline_data) do
        { sounds: { dog: 'woof' } }
      end

      let(:path) { [:sounds, :dog] }

      it 'can find a simple path' do
        expect(use_case).to eq(found: 'woof')
      end
    end
  end

  context 'with paths that include a single item array' do
    context 'example 1' do
      let(:baseline_data) do
        { noises: [{ cat: 'meow' }] }
      end
      let(:path) { [:noises, :cat] }

      it 'can find a relevent item for a single item array' do
        expect(use_case).to eq(found: ['meow'])
      end
    end

    context 'example 2' do
      let(:baseline_data) do
        { sounds: [{ dog: 'woof' }] }
      end
      let(:path) { [:sounds, :dog] }

      it 'can find a relevent item for a single item array' do
        expect(use_case).to eq(found: ['woof'])
      end
    end
  end

  context 'with paths that include a multi item array' do
    let(:baseline_data) do
      { noises: [{ cat: 'meow' }, { cat: 'nyan' }] }
    end
    let(:path) { [:noises, :cat] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: ['meow','nyan'])
    end
  end

  context 'with paths that include a multi item array that contain somewhat complex hashes' do
    let(:baseline_data) do
      { noises: [{ cat: { type: 'tabby'} }, { cat: { type: 'tom'} }] }
    end
    let(:path) { [:noises, :cat, :type] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: ['tabby','tom'])
    end
  end

  context 'hash in item array in hash in item array ' do
    let(:baseline_data) do
      {
        noises:
        [
          {
            cat:
            {
              parents:
              [
                {type: 'tabby'},
                {type: 'tom'}
              ]
            }
          },
          {
            cat:
            { parents:
              [
                {type: 'aegean'},
                {type: 'abyssinian'}
              ]
            }
          }
        ]
      }
    end
    let(:path) { [:noises, :cat, :parents, :type] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: [['tabby','tom'],['aegean','abyssinian']])
    end
  end

  context 'realistic test' do
    let(:baseline_data) do
      {
        infrastructures: [
          {
            milestones: [
              {
                descriptionOfMilestone: "Milestone One"
              },
              {
                descriptionOfMilestone: "Milestone Two"
              }
            ]
          }
        ]
      }
    end
    let(:path) { [:infrastructures, :milestones, :descriptionOfMilestone] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: [["Milestone One", "Milestone Two"]])
    end
  end

  context 'non-existent path' do
    let(:baseline_data) do
      {
        infrastructures: []
      }
    end
    let(:path) { [:infrastructures, :milestones, :descriptionOfMilestone] }
    it 'finds nothing' do
      expect(use_case).to eq({})
    end
  end

  context 'deciding between return and baseline data' do
    context 'return data exists' do
      let(:baseline_data) do
        {
          baseline_data: {
            infrastructures: {
              cats: {
                puppies: 'Get me this data'
              }
            }
          },
          return_data: {
            returning_infrastructures: {
              puppies: 'or this data'
            }
          }
        }
      end
      let(:path) do
        [
          :return_or_baseline,
          [:baseline_data, :infrastructures, :cats, :puppies],
          [:return_data, :returning_infrastructures, :puppies]
        ]
      end

      it 'can get the data from the return data' do
        expect(use_case).to eq(found: 'or this data')
      end
    end

    context 'return data doesnt exist' do
      let(:baseline_data) do
        {
          baseline_data: {
            infrastructures: {
              cats: {
                puppies: 'Get me this data'
              }
            }
          }
        }
      end
      let(:path) do
        [
          :return_or_baseline,
          [:baseline_data, :infrastructures, :cats, :puppies],
          [:return_data, :returning_infrastructures, :puppies]
        ]
      end

      it 'can get the data from the baseline data' do
        expect(use_case).to eq(found: 'Get me this data')
      end
    end

    context 'return data doesnt exist in an array' do
      let(:baseline_data) do
        {
          baseline_data: {
            infrastructures: [
              puppies: 'Get me this data'
            ]
          }
        }
      end
      let(:path) do
        [
          :return_or_baseline,
          [:baseline_data, :infrastructures, :puppies],
          [:return_data, :infrastructure, :puppies]
        ]
      end

      it 'can get the data from the baseline data' do
        expect(use_case).to eq(found: ['Get me this data'])
      end
    end

    context 'some return data exists' do
      context 'example 1' do
        let(:baseline_data) do
          {
            baseline_data: {
              infrastructures: [
                {item: 1},
                {},
                {item: 3}
              ]
            },
            return_data: {
              infrastructures: [
                {item: 6},
                {item: 2}
              ]
            }
          }
        end

        let(:path) do
          [
            :return_or_baseline,
            [:baseline_data, :infrastructures, :item],
            [:return_data, :infrastructures, :item]
          ]
        end

        it 'pulls only the data not present' do
          expect(use_case).to eq(found: [6, 2, 3])
        end
      end

      context 'example 2' do
        let(:baseline_data) do
          {
            baseline_data: {
              infrastructures: [
                {name: 'Dan'},
                {name: 'Robin'},
                {name: 'Barry'},
                {name: 'Chris'}
              ]
            },
            return_data: {
              infrastructures: [
                {},
                {},
                {name: 'Faissal'}
              ]
            }
          }
        end

        let(:path) do
          [
            :return_or_baseline,
            [:return_data, :infrastructures, :name],
            [:baseline_data, :infrastructures, :name]
          ]
        end

        it 'pulls only the data not present' do
          expect(use_case).to eq(found: ['Dan', 'Robin', 'Faissal', 'Chris'])
        end
      end
    end
  end
end
