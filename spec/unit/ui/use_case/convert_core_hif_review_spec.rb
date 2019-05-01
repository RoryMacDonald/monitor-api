describe UI::UseCase::ConvertCoreHifReview do
  let(:review_to_convert) do
    {
      date: '01/01/1990'
    }
  end
  let(:ui_data_review) do
    {
      date: '01/01/1990'
    }
  end
  let(:usecase) { described_class.new }

  it 'converts the core data to UI data' do
    expect(usecase.execute(review_data: review_to_convert)).to eq(ui_data_review)
  end
end
