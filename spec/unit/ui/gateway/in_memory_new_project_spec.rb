describe UI::Gateway::InMemoryNewProject do
  it 'Returns a blank project when finding by type hif' do
    gateway = described_class.new
    project = gateway.find_by(type: 'hif')
    expect(project).not_to be_nil
  end

  it 'Returns a blank project when finding by type ac' do
    gateway = described_class.new
    project = gateway.find_by(type: 'ac')
    expect(project).not_to be_nil
  end

  it 'Returns nil when searching for a non existing type' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'cats 4 lyf')
    expect(schema).to be_nil
  end
end