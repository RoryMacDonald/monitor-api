describe UI::UseCase::ConvertUiHifReview do
  let(:review_to_convert) do
    {
      date: '01/01/1990'
    }
  end
  let(:core_data_review) do
    {
      date: '01/01/1990'
    }
  end
  let(:usecase) { described_class.new }

  it 'converts the UI data to core data' do
    expect(usecase.execute(review_data: review_to_convert)).to eq(core_data_review)
  end
end
