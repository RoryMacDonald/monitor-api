# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Unsubmitting a submitted project' do
  include_context 'dependency factory'

  context 'Whilst BACK_TO_BASELINE is true' do
    let(:back_to_baseline) { ENV['BACK_TO_BASELINE'] }
    before do
      back_to_baseline
      ENV['BACK_TO_BASELINE'] = 'yes'
    end

    after do
      ENV['BACK_TO_BASELINE'] = back_to_baseline
    end

    it 'Changes the status to Draft' do
      project_baseline = {
        summary: {
          project_name: '',
          description: '',
          lead_authority: ''
        },
        infrastructure: {
          type: '',
          description: '',
          completion_date: '',
          planning: {
            submission_estimated: ''
          }
        },
        financial: {
          total_amount_estimated: ''
        }
      }
      project_id = get_use_case(:create_new_project).execute(
        name: 'cat project',
        type: 'hif',
        baseline: project_baseline,
        bid_id: 'HIF/MV/11'
      )[:id]

      get_use_case(:submit_project).execute(project_id: project_id)

      expect(get_use_case(:find_project).execute(id: project_id)[:status]).to eq('Submitted')

      return_id = get_use_case(:create_return).execute(project_id: project_id, data: {some_data: "fun"})[:id]
      get_use_case(:submit_return).execute(return_id: return_id)

      expect(get_use_case(:get_returns).execute(project_id: project_id)[:returns].length).to eq(1)


      get_use_case(:unsubmit_project).execute(project_id: project_id)

      project = get_use_case(:find_project).execute(id: project_id)

      expect(project[:status]).to eq('Draft')
      expect(project[:data]).to eq(project_baseline)
      expect(get_use_case(:get_returns).execute(project_id: project_id)[:returns].length).to eq(0)
    end
  end

  context 'Whilst BACK_TO_BASELINE is true' do
    let(:back_to_baseline) { ENV['BACK_TO_BASELINE'] }
    before do
      back_to_baseline
      ENV['BACK_TO_BASELINE'] = nil
    end

    after do
      ENV['BACK_TO_BASELINE'] = back_to_baseline
    end

    it 'Doesnt change anything' do
      project_baseline = {
        summary: {
          project_name: '',
          description: '',
          lead_authority: ''
        },
        infrastructure: {
          type: '',
          description: '',
          completion_date: '',
          planning: {
            submission_estimated: ''
          }
        },
        financial: {
          total_amount_estimated: ''
        }
      }
      project_id = get_use_case(:create_new_project).execute(
        name: 'cat project',
        type: 'hif',
        baseline: project_baseline,
        bid_id: 'HIF/MV/555'
      )[:id]



      get_use_case(:submit_project).execute(project_id: project_id)

      expect(get_use_case(:find_project).execute(id: project_id)[:status]).to eq('Submitted')

      return_id = get_use_case(:create_return).execute(project_id: project_id, data: {some_data: "fun"})[:id]
      get_use_case(:submit_return).execute(return_id: return_id)

      expect(get_use_case(:get_returns).execute(project_id: project_id)[:returns].length).to eq(1)


      get_use_case(:unsubmit_project).execute(project_id: project_id)

      project = get_use_case(:find_project).execute(id: project_id)

      expect(project[:status]).to eq('Submitted')
      expect(project[:data]).to eq(project_baseline)
      expect(get_use_case(:get_returns).execute(project_id: project_id)[:returns].length).to eq(1)
    end
  end
end
