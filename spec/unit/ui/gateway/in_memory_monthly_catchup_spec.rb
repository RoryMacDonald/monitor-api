fdescribe UI::Gateway::InMemoryMonthlyCatchupSchemaGateway do
  it 'returns the schema domain object' do
    schema = described_class.new.find_by(type: 'hif')
    expect(schema).not_to be_nil
  end

  it 'returns null if the type is not hif' do
    schema = described_class.new.find_by(type: 'ac')
    expect(schema).to be_nil
  end
end
