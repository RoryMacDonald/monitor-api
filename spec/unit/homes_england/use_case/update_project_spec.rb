# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::UpdateProject do
  context 'first update' do
    let(:use_case) do
      described_class.new(
        baseline_gateway: baseline_gateway_spy
      )
    end

    let(:response) do
      use_case.execute(
        project_id: project_id,
        project_data: updated_project_data,
        timestamp: timestamp
      )
    end

    let(:time_now) { Time.now }

    let(:baseline_gateway_spy) do
      spy(
        versions_for: [baseline_data]
      )
    end

    before do
      Timecop.freeze(time_now)
      response
    end

    after do
      Timecop.return
    end


    context 'example one' do
      let(:project_id) { 42 }

      let(:updated_project_data) { { ducks: 'quack' } }

      context 'given a successful update whilst in Draft status' do
        let(:timestamp) { 0 }
        let(:baseline_data) do
          HomesEngland::Domain::Baseline.new.tap do |b|
            b.status = 'Draft',
              b.id = 34
            b.project_id = 42
            b.data = { a: 'b' }
            b.timestamp = 0
            b.version = 1
          end
        end

        it 'Should get all versions from the gateway' do
          expect(baseline_gateway_spy).to have_received(:versions_for).with(project_id: 42)
        end

        it 'Should pass the ID to the baseline gateway' do
          expect(baseline_gateway_spy).to have_received(:update).with(
            hash_including(id: 34)
          )
        end

        it 'Should pass the baseline to the gateway' do
          expect(baseline_gateway_spy).to have_received(:update) do |request|
            project = request[:baseline]
            expect(project.data).to eq(ducks: 'quack')
          end
        end

        it 'Should pass Draft status to the gateway' do
          expect(baseline_gateway_spy).to have_received(:update) do |request|
            project = request[:baseline]
            expect(project.status).to eq('Draft')
          end
        end

        it 'Should return successful, no errors and a timestamp' do
          expect(response).to eq(successful: true, errors: [], timestamp: time_now.to_i)
        end
      end

      context 'given an incorrect timestamp' do
        let(:timestamp) { 0 }

        let(:baseline_data) do
          HomesEngland::Domain::Baseline.new.tap do |p|
            p.status = 'Draft'
            p.id = 34
            p.project_id = 42
            p.data = { a: 'b' }
            p.timestamp = 5
          end
        end

        it 'does not pass the data to the gateway' do
          expect(baseline_gateway_spy).not_to have_received(:update)
        end

        it 'returns unsuccessful' do
          expect(response[:successful]).to eq(false)
        end

        it 'returns an incorrect timestamp error' do
          expect(response[:errors]).to eq([:incorrect_timestamp])
        end

        it 'returns an unchanged timestamp' do
          expect(response[:timestamp]).to eq(0)
        end
      end
    end

    context 'example two' do
      let(:project_id) { 123 }
      let(:updated_project_data) { { cows: 'moo' } }

      context 'given a successful update whilst in Draft status' do
        let(:timestamp) { 0 }
        let(:baseline_data) do
          HomesEngland::Domain::Baseline.new.tap do |p|
            p.status = 'Draft'
            p.data = { b: 'c' }
            p.id = 78
            p.timestamp = 0
          end
        end

        it 'should get all the versions from the gateway' do
          expect(baseline_gateway_spy).to have_received(:versions_for).with(project_id: 123)
        end

        it 'Should pass the ID to the gateway' do
          expect(baseline_gateway_spy).to have_received(:update).with(
            hash_including(id: 78)
          )
        end

        it 'Should pass the project to the gateway' do
          expect(baseline_gateway_spy).to have_received(:update) do |request|
            project = request[:baseline]
            expect(project.data).to eq(cows: 'moo')
          end
        end

        it 'Should return successful' do
          expect(response).to eq(successful: true, errors: [], timestamp: time_now.to_i)
        end

        it 'Should pass Draft status to the gateway' do
          expect(baseline_gateway_spy).to have_received(:update) do |request|
            project = request[:baseline]
            expect(project.status).to eq('Draft')
          end
        end
      end

      context 'given an incorrect timestamp' do
        let(:timestamp) { 4 }

        let(:baseline_data) do
          HomesEngland::Domain::Baseline.new.tap do |p|
            p.status = 'Draft'
            p.data = { c: 'd' }
            p.timestamp = 9
          end
        end

        it 'does not pass the data to the gateway' do
          expect(baseline_gateway_spy).not_to have_received(:update)
        end

        it 'returns unsuccessful' do
          expect(response[:successful]).to eq(false)
        end

        it 'returns an incorrect timestamp error' do
          expect(response[:errors]).to eq([:incorrect_timestamp])
        end

        it 'returns an unchanged timestamp' do
          expect(response[:timestamp]).to eq(4)
        end
      end
    end
  end

  context 'second update' do
    it 'Increases the timestamp' do
      time_now = Time.now
      Timecop.freeze(time_now)
      new_time = time_now.to_i - 1

      current_baseline = HomesEngland::Domain::Baseline.new.tap do |p|
        p.status = 'Draft'
        p.id = 345
        p.data = { a: 'b' }
        p.timestamp = new_time
      end

      baseline_gateway_spy = spy(
        versions_for: [current_baseline],
      )

      use_case = described_class.new(baseline_gateway: baseline_gateway_spy)

      response = use_case.execute(
        project_id: 4,
        project_data: { ducks: 'Quack' },
        timestamp: new_time
      )

      expect(baseline_gateway_spy).to have_received(:update) do |request|
        project = request[:baseline]
        expect(project.timestamp).to be > new_time
      end

      Timecop.return
    end
  end

  context 'updating a submitted baseline' do
    let(:time) { Time.now.to_i + 100 }
    let(:current_baseline) do
      HomesEngland::Domain::Baseline.new.tap do |p|
        p.status = 'Submitted'
        p.id = 345
        p.data = { a: 'b' }
        p.timestamp = time
      end
    end

    let(:baseline_gateway_spy) { spy(versions_for: [current_baseline]) }
    let(:use_case) { described_class.new(baseline_gateway: baseline_gateway_spy) }
    let(:response) do
      use_case.execute(
        project_id: 4,
        project_data: { ducks: 'Quack' },
        timestamp: time
      )
    end

    before { response }

    it 'Returns successful false' do
      expect(response[:successful]).to eq(false)
    end

    it 'Returns an submitted project error' do
      expect(response[:errors][0]).to eq(:project_already_submitted)
    end

    it 'Does not update the baseline' do
      expect(baseline_gateway_spy).not_to have_received(:update)
    end
  end
end
