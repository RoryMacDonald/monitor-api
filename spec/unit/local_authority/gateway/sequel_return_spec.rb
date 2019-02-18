# frozen_string_literal: true

describe LocalAuthority::Gateway::SequelReturn do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  let(:return_update_gateway) do
    LocalAuthority::Gateway::SequelReturnUpdate.new(database: database)
  end

  context 'example one' do
    let(:project_id) { database[:projects].insert(type: 'hif', bid_id: 'HIF/MV/555') }
    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = project_id
        r.status = 'Draft'
      end
    end
    let(:return_id) { gateway.create(project_return) }

    before do
      project_id
      return_id
    end

    it 'finds the created return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.id).to eq(return_id)
      expect(found_return.type).to eq('hif')
      expect(found_return.bid_id).to eq('HIF/MV/555')
      expect(found_return.project_id).to eq(project_id)
      expect(found_return.status).to eq('Draft')
      expect(found_return.timestamp).to eq(0)
    end
  end

  context 'example two' do
    let(:project_id) { database[:projects].insert(type: 'ac', bid_id: 'AC/MV/15') }

    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = project_id
        r.status = 'Submitted'
      end
    end
    let(:return_id) { gateway.create(project_return) }

    before do
      project_id
      return_id
    end

    it 'finds the created return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.id).to eq(return_id)
      expect(found_return.type).to eq('ac')
      expect(found_return.project_id).to eq(project_id)
      expect(found_return.bid_id).to eq('AC/MV/15')
      expect(found_return.status).to eq('Submitted')
      expect(found_return.timestamp).to eq(0)
    end
  end

  context 'with multiple returns' do
    let(:project_id) { database[:projects].insert(type: 'ac', bid_id: 'AC/MV/15') }

    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = project_id
        r.status = 'Submitted'
      end
    end
    let(:return_id) do
      gateway.create(project_return)
    end

    before do
      gateway.create(project_return)
      project_id
      return_id
    end

    it 'finds the created return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.id).to eq(return_id)
      expect(found_return.bid_id).to eq('AC/MV/15')
      expect(found_return.type).to eq('ac')
      expect(found_return.project_id).to eq(project_id)
      expect(found_return.status).to eq('Submitted')
    end
  end
end
