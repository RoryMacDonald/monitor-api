# frozen_string_literal: true

describe HomesEngland::UseCase::SubmitProject do
  describe 'When status is Draft' do
    let(:project_gateway) { spy(status: 'Draft') }
    let(:baseline_gateway) do
      spy(versions_for: [baseline])
    end
    let(:use_case) do
      described_class.new(
        project_gateway: project_gateway,
        baseline_gateway: baseline_gateway
      )
    end
    
    before { use_case.execute(project_id: project_id) }

    context 'Example 1' do
      let(:project_id) { 1 }
      let(:baseline) do
        HomesEngland::Domain::Baseline.new.tap do |b|
          b.id = 23
        end
      end
      it 'calls the submit method on the project gateway' do
        expect(project_gateway).to have_received(:submit).with(id: 1, status: 'Submitted')
      end

      it 'get the baseline id from the gateway' do
        expect(baseline_gateway).to have_received(:versions_for).with(project_id: 1)
      end

      it 'calls the submit method on the baseline gateway' do
        expect(baseline_gateway).to have_received(:submit).with(id: 23)
      end
    end

    context 'Example 2' do
      let(:project_id) { 7 }
      let(:baseline) do
        HomesEngland::Domain::Baseline.new.tap do |b|
          b.id = 67
        end
      end

      it 'calls the submit method on the project gateway' do
        expect(project_gateway).to have_received(:submit).with(id: 7, status: 'Submitted')
      end

      it 'get the baseline id from the gateway' do
        expect(baseline_gateway).to have_received(:versions_for).with(project_id: 7)
      end

      it 'calls the submit method on the baseline gateway' do
        expect(baseline_gateway).to have_received(:submit).with(id: 67)
      end
    end
  end
end
