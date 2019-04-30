require 'rspec'

describe HomesEngland::UseCase::CreateNewRmReview do
  let(:rm_review_id) { 0 }
  let(:rm_review_gateway) { spy(create: rm_review_id) }
  let(:project_gateway) { spy }
  let(:use_case) { described_class.new(rm_review_gateway: rm_review_gateway) }

  context 'calls create in rm_review gateway' do
    example 1 do
      use_case.execute(project_id: 3, review_data: {})
      expect(rm_review_gateway).to have_received(:create) do |rm_review|
        expect(rm_review.project_id).to eq(3)
        expect(rm_review.data).to eq({})
        expect(rm_review.status).to eq('Draft')
      end
    end

    example 2 do
      use_case.execute(project_id: 7, review_data: {
        date: '24/01/2001'
      })
      expect(rm_review_gateway).to have_received(:create) do |rm_review|
        expect(rm_review.project_id).to eq(7)
        expect(rm_review.data).to eq({ date: '24/01/2001' })
        expect(rm_review.status).to eq('Draft')
      end
    end
  end

  context 'return value' do
    context 'example 1' do
      let(:rm_review_id) { 1 }

      it 'returns the correct id' do
        response = use_case.execute(project_id: 7, review_data: {
          date: '24/01/2001'
        })

        expect(response[:id]).to eq(1)
      end
    end

    context 'example 2' do
      let(:rm_review_id) { 2 }

      it 'returns the correct id' do
        response = use_case.execute(project_id: 2, review_data: {
          date: '09/05/2001'
        })

        expect(response[:id]).to eq(2)
      end
    end
  end
end
