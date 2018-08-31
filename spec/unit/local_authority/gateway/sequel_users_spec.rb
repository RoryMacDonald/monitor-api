describe LocalAuthority::Gateway::SequelUsers do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context 'example one' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'example@example.com'
          u.projects = [1]
        end
      )
    end

    it 'returns an id for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user.id).to eq(created_user_id)
    end

    it 'return nil when the email is not found' do
      new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user).to eq(nil)
    end

    it 'grants permission for an email to access a given project' do
      new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user.projects).to eq([1])
    end

    it 'updates the user' do
      new_user_id
      user_to_update = gateway.find_by(email: 'example@example.com')
      user_to_update.projects = [2, 4, 8, 16]
      gateway.update(user_to_update)
      user = gateway.find_by(email: 'example@example.com')
      expect(user.projects).to eq([2, 4, 8, 16])
    end
  end

  context 'example two' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'cats@cathouse.com'
        end
      )
    end

    it 'returns an id for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user.id).to eq(created_user_id)
    end

    it 'return nil when the email is not found' do
      new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user).to eq(nil)
    end

    it 'grants permission for an email to access a given project' do
      new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user.projects).to eq([])
    end
  end
end