describe HomesEngland::UseCase::ChangeUserRole do
  let(:user) { nil }

  let(:user_gateway) do
    spy(find_by: user)
  end
  let(:usecase) { described_class.new(user_gateway: user_gateway) }

  context 'example 1' do
    let(:user) do
      LocalAuthority::Domain::User.new.tap do |u|
        u.id = 1
        u.email = 'cat@cathouse.com'
        u.role = 'Homes England'
        u.projects = [8]
      end
    end

    it 'calls the user gateway with the specified email' do
      usecase.execute(email: 'cat@cathouse.com', role: 'Superuser')
      expect(user_gateway).to have_received(:find_by).with(email: 'cat@cathouse.com')
    end

    it 'calls update gateway with an updated user role' do
      usecase.execute(email: 'cat@cathouse.com', role: 'Superuser')
      expect(user_gateway).to have_received(:update) do |user|
        expect(user.id).to eq(1)
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.projects).to eq([8])
        expect(user.role).to eq('Superuser')
      end
    end
  end

  context 'example 2' do
    let(:user) do
      LocalAuthority::Domain::User.new.tap do |u|
        u.id = 6
        u.email = 'dog@dog.net'
        u.role = 'Local Authority'
        u.projects = []
      end
    end

    it 'calls the user gateway with the specified email' do
      usecase.execute(email: 'cat@cathouse.com', role: 'Homes England')
      expect(user_gateway).to have_received(:find_by).with(email: 'cat@cathouse.com')
    end

    it 'calls the update gateway with an updated user role' do
      usecase.execute(email: 'cat@cathouse.com', role: 'Homes England')
      expect(user_gateway).to have_received(:update) do |user|
        expect(user.id).to eq(6)
        expect(user.email).to eq('dog@dog.net')
        expect(user.projects).to eq([])
        expect(user.role).to eq('Homes England')
      end
    end
  end
end
