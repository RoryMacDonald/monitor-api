describe UI::Gateway::InMemoryClaimSchema do
  it 'Returns a schema when finding by type hif' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'hif')
    expect(schema).not_to be_nil
  end

  it 'Returns a schema when finding by type ac' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'ac')
    expect(schema).not_to be_nil
  end

  it 'Returns nil when searching for a non existing type' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'cats 4 lyf')
    expect(schema).to be_nil
  end
end
