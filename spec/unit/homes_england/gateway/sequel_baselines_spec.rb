describe HomesEngland::Gateway::SequelBaseline do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context '#FindBy' do
    context 'example one' do
      let(:baseline) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 1
          baseline.data = { cats: "meow" }
          baseline.version = 2
        end
      end
      let(:baseline_id) { gateway.create(baseline) }

      before { baseline_id }

      it 'creates the new baseline data' do
        baseline = gateway.find_by(id: baseline_id)

        expect(baseline.project_id).to eq(1)
        expect(baseline.version).to eq(2)
        expect(baseline.status).to eq("Draft")
        expect(baseline.data).to eq(cats: "meow")
      end
    end

    context 'example two' do
      let(:baseline) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 5
          baseline.version = 13
          baseline.data = {
            animals: [
              { cat: 'meow' },
              {
                dog: {
                  angry: 'bark',
                  happy: 'woof'
                }
              }
            ]
          }
        end
      end
      let(:baseline_id) { gateway.create(baseline) }

      before { baseline_id }

      it 'creates the new return update' do
        baseline = gateway.find_by(id: baseline_id)

        expect(baseline.project_id).to eq(5)
        expect(baseline.version).to eq(13)
        expect(baseline.status).to eq('Draft')
        expect(baseline.data).to eq(
          animals: [
            { cat: 'meow' },
            { dog: {
                angry: 'bark',
                happy: 'woof'
              }
            }
          ]
        )
      end
    end
  end

  context '#Update' do
    context 'example one' do
      let(:baseline) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 1
          baseline.data = { cats: "meow" }
          baseline.version = 2
          baseline.timestamp = 0
        end
      end

      let(:updated_baseline) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 1
          baseline.data = { ducks: 'quack' }
          baseline.version = 2
          baseline.timestamp = 12345
        end
      end
      let(:baseline_id) { gateway.create(baseline) }

      before do
        gateway.update(id: baseline_id, baseline: updated_baseline)
      end

      it 'saves the new data' do 
        found_baseline = gateway.find_by(id: baseline_id)
        expect(found_baseline.project_id).to eq(1)
        expect(found_baseline.data).to eq({ ducks: 'quack' })
        expect(found_baseline.version).to eq(2)
        expect(found_baseline.timestamp).to eq(12345)
      end
    end

    context 'example two' do
      let(:baseline) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 4
          baseline.data = { cats: "meow" }
          baseline.version = 5
          baseline.timestamp = 0
        end
      end

      let(:updated_baseline) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 4
          baseline.data = { crocodiles: 'rarrr' }
          baseline.version = 5
          baseline.timestamp = 123422225
        end
      end
      let(:baseline_id) { gateway.create(baseline) }

      before do
        gateway.update(id: baseline_id, baseline: updated_baseline)
      end

      it 'saves the new data' do 
        found_baseline = gateway.find_by(id: baseline_id)
        expect(found_baseline.project_id).to eq(4)
        expect(found_baseline.data).to eq({ crocodiles: 'rarrr' })
        expect(found_baseline.version).to eq(5)
        expect(found_baseline.timestamp).to eq(123422225)
      end
    end
  end

  context '#Submit' do 
    let(:baseline) do
      HomesEngland::Domain::Baseline.new.tap do |baseline|
        baseline.project_id = 1
        baseline.data = { cats: "meow" }
        baseline.version = 2
        baseline.timestamp = 0
      end
    end
    let(:baseline_id) { gateway.create(baseline) }

    before do 
      gateway.submit(id: baseline_id)
    end

    it 'marks the baseline as submitted' do
      baseline = gateway.find_by(id: baseline_id)
      expect(baseline.status).to eq('Submitted')
    end
  end

  context '#VersionsFor' do
    context 'Example one' do
      let(:version1) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 10
          baseline.data = {cats: 'meow'}
          baseline.version = 1
          baseline.timestamp = 13
        end
      end

      let(:version2) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 10
          baseline.data = {dogs: 'woof'}
          baseline.timestamp = 100
          baseline.version = 2
        end
      end

      context 'with one version of the baseline' do
        before { gateway.create(version1) }

        it 'finds the version for the baseline' do
          found_versions = gateway.versions_for(project_id: 10)

          expect(found_versions.first.data).to eq(cats: 'meow')
          expect(found_versions.first.version).to eq(1)
        end
      end

      context 'with two versions of the baseline' do
        before do
          gateway.create(version1)
          gateway.create(version2)
        end

        it 'finds both version of the baseline' do
          found_versions = gateway.versions_for(project_id: 10)

          expect(found_versions[0].data).to eq(cats: 'meow')
          expect(found_versions[0].version).to eq(1)
          expect(found_versions[1].data).to eq(dogs: 'woof')
          expect(found_versions[1].version).to eq(2)
        end
      end
    end

    context 'Example two' do
      let(:version1) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 77
          baseline.data = {cows: 'moo'}
          baseline.version = 3
        end
      end

      let(:version2) do
        HomesEngland::Domain::Baseline.new.tap do |baseline|
          baseline.project_id = 77
          baseline.data = {ducks: 'quack'}
          baseline.version = 4
        end
      end

      context 'with one version of the baseline' do
        before { gateway.create(version1) }

        it 'finds the update for the return' do
          found_versions = gateway.versions_for(project_id: 77)

          expect(found_versions.first.data).to eq(cows: 'moo')
        end
      end

      context 'with two versions of the baseline' do
        before do
          gateway.create(version1)
          gateway.create(version2)
        end

        it 'finds both versions' do
          found_versions = gateway.versions_for(project_id: 77)

          expect(found_versions[0].data).to eq(cows: 'moo')
          expect(found_versions[0].version).to eq(3)
          expect(found_versions[1].data).to eq(ducks: 'quack')
          expect(found_versions[1].version).to eq(4)
        end
      end
    end
  end
end
