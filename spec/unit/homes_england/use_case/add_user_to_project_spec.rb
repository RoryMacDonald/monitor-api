describe HomesEngland::UseCase::AddUserToProject do
  let(:user_gateway) { spy(find_by: nil) }
  let(:project_gateway_spy) do
    spy(all: [
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = 1
      end,
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = 2
      end,
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = 3
      end,
      HomesEngland::Domain::Project.new.tap do |p|
        p.id = 4
      end
    ])
  end
  let(:use_case) { described_class.new(user_gateway: user_gateway, project_gateway: project_gateway_spy) }

  context 'calls the gateway for a user with a lowercase email and a role' do
    it 'example 1' do
      use_case.execute(email: 'Cat@caThouse.com', role: 'Homes England', project_id: 1)
      expect(user_gateway).to have_received(:create) do |user|
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.role).to eq('Homes England')
        expect(user.projects).to eq([1])
      end
    end

    it 'example 2' do
      use_case.execute(email: 'dog@CAThouse.com', role: 'Local Authority', project_id: 4)
      expect(user_gateway).to have_received(:create) do |user|
        expect(user.email).to eq('dog@cathouse.com')
        expect(user.role).to eq('Local Authority')
        expect(user.projects).to eq([4])
      end
    end
  end

  context 'call the gateway for a user that already has data' do
    let(:new_user) do
      LocalAuthority::Domain::User.new.tap do |u|
        u.id = 1
        u.email = 'cat@cathouse.com'
        u.projects = [8]
      end
    end
    let(:user_gateway) do
      spy(
        find_by: new_user
      )
    end
    it 'example 1' do
      use_case.execute(email: 'cat@cathouse.com', project_id: 2)
      expect(user_gateway).to have_received(:update) do |user|
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.projects).to eq([8, 2])
      end
    end

    it 'example 2' do
      use_case.execute(email: 'cat@cathouse.com', project_id: 3)
      expect(user_gateway).to have_received(:update) do |user|
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.projects).to eq([8, 3])
      end
    end
  end

  context 'the project does not exist' do
    let(:project_gateway_spy) do
      spy(
        all: []
      )
    end

    it 'calls the project gateway' do
      use_case.execute(email: 'email@email', role: 'LA', project_id: 7)
      expect(project_gateway_spy).to have_received(:all)
    end

    it 'will not call the user gateway' do
      expect(user_gateway).not_to have_received(:create)
      expect(user_gateway).not_to have_received(:update)
    end
  end
end
