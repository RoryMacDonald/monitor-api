fdescribe HomesEngland::Gateway::InMemoryMonthlyCatchupTemplate do
  it 'returns the hif monthly catchup schema' do
    response = described_class.new.execute(type: 'hif')
    expect(response).not_to be_nil
  end

  it 'returns nil for non-hif schemes' do
    response = described_class.new.execute(type: 'ac')
    expect(response).to be_nil
  end
end
