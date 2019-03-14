describe UI::Gateway::InMemoryNewProject do
  context 'with environment variables enabled' do
    let (:ff_enabled) { ENV['FF_CREATION'] }
    before do
      ff_enabled
      ENV['FF_CREATION'] = 'yes'
    end
    after do
      ENV['FF_CREATION'] = nil
    end

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

    it 'Returns a blank project when finding by type ff' do
      gateway = described_class.new
      project = gateway.find_by(type: 'ff')
      expect(project).not_to be_nil
    end

    it 'Returns nil when searching for a non existing type' do
      gateway = described_class.new
      schema = gateway.find_by(type: 'cats 4 lyf')
      expect(schema).to be_nil
    end
  end

  context 'without environment variables enabled' do
    let (:ff_disabled) { ENV['FF_CREATION'] }
    before do
      ff_disabled
      ENV['FF_CREATION'] = nil
    end
    after do
      ENV['FF_CREATION'] = 'yes'
    end
    it 'Does not return a blank project for ff' do
      gateway = described_class.new
      project = gateway.find_by(type: 'ff')
      expect(project).to be_nil
    end
  end
end
