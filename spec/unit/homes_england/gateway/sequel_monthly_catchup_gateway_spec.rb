describe HomesEngland::Gateway::SequelMonthlyCatchup do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context 'can create and find a monthly_catchup' do
    example 1 do
      monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
        monthly_catchup.project_id = 1
        monthly_catchup.data = {}
        monthly_catchup.status = 'Draft'
      end

      new_monthly_catchup_id = gateway.create(monthly_catchup)
      found_monthly_catchup = gateway.find_by(id: new_monthly_catchup_id)

      expect(found_monthly_catchup.id).to eq(new_monthly_catchup_id)
      expect(found_monthly_catchup.project_id).to eq(1)
      expect(found_monthly_catchup.data).to eq({})
      expect(found_monthly_catchup.status).to eq('Draft')
    end

    example 2 do
      monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
        monthly_catchup.project_id = 2
        monthly_catchup.data = { cats: 'meow' }
        monthly_catchup.status = 'Submitted'
      end

      new_monthly_catchup_id = gateway.create(monthly_catchup)
      found_monthly_catchup = gateway.find_by(id: new_monthly_catchup_id)

      expect(found_monthly_catchup.id).to eq(new_monthly_catchup_id)
      expect(found_monthly_catchup.project_id).to eq(2)
      expect(found_monthly_catchup.data).to eq({ cats: "meow" })
      expect(found_monthly_catchup.status).to eq('Submitted')
    end
  end

  context 'can update a monthly_catchup' do
    example 1 do
      monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
        monthly_catchup.project_id = 3
        monthly_catchup.data = { cats: 'sock' }
        monthly_catchup.status = 'Draft'
      end

      new_monthly_catchup_id = gateway.create(monthly_catchup)

      monthly_catchup.id = new_monthly_catchup_id
      monthly_catchup.data = { cats: 'not socks'}

      gateway.update(monthly_catchup)

      found_monthly_catchup = gateway.find_by(id: new_monthly_catchup_id)

      expect(found_monthly_catchup.id).to eq(new_monthly_catchup_id)
      expect(found_monthly_catchup.project_id).to eq(3)
      expect(found_monthly_catchup.data).to eq({ cats: 'not socks' })
      expect(found_monthly_catchup.status).to eq('Draft')
    end

    example 2 do
      monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
        monthly_catchup.project_id = 7
        monthly_catchup.data = { dogs: 'none' }
        monthly_catchup.status = 'Draft'
      end

      new_monthly_catchup_id = gateway.create(monthly_catchup)

      monthly_catchup.id = new_monthly_catchup_id
      monthly_catchup.data = { dogs: 'woof' }

      gateway.update(monthly_catchup)

      found_monthly_catchup = gateway.find_by(id: new_monthly_catchup_id)

      expect(found_monthly_catchup.id).to eq(new_monthly_catchup_id)
      expect(found_monthly_catchup.project_id).to eq(7)
      expect(found_monthly_catchup.data).to eq({ dogs: 'woof' })
      expect(found_monthly_catchup.status).to eq('Draft')
    end
  end

  it 'can submit a monthly_catchup' do
    monthly_catchup = HomesEngland::Domain::RmMonthlyCatchup.new.tap do |monthly_catchup|
      monthly_catchup.project_id = 3
      monthly_catchup.data = { cats: 'sock' }
      monthly_catchup.status = 'Draft'
    end

    new_monthly_catchup_id = gateway.create(monthly_catchup)

    gateway.submit(id: new_monthly_catchup_id)

    found_monthly_catchup = gateway.find_by(id: new_monthly_catchup_id)

    expect(found_monthly_catchup.id).to eq(new_monthly_catchup_id)
    expect(found_monthly_catchup.status).to eq('Submitted')
  end
end
