describe LocalAuthority::Gateway::SequelUsers do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context 'example one' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'example@example.com'
          u.role = 'Local Authority'
          u.projects = [1]
        end
      )
    end

    it 'returns a role for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user.role).to eq('Local Authority')
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
      user_to_update.role = 'Homes England'
      gateway.update(user_to_update)
      user = gateway.find_by(email: 'example@example.com')
      expect(user.projects).to eq([2, 4, 8, 16])
      expect(user.role).to eq('Homes England')
    end

    it 'gets multiple users' do
      user_one = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'example@example.com'
        u.role = 'S151'
        u.projects = [1]
      end
      user_two = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'cat@cathouse.com'
        u.role = 'Local Authority'
        u.projects = [1]
      end
      gateway.create(
        user_one
      )
      gateway.create(
        user_two
      )

      users = gateway.get_users(project_id: 1)
      expect(users.length).to eq(2)
      expect(users[0].email).to eq('example@example.com')
      expect(users[0].role).to eq('S151')
      expect(users[1].email).to eq('cat@cathouse.com')
      expect(users[1].role).to eq('Local Authority')
    end

    it 'deletes a user' do
      new_user_id
      user_to_delete = gateway.find_by(email: 'example@example.com')
      gateway.delete_user('example@example.com')
      user = gateway.find_by(email: 'example@example.com')
      expect(user).to eq(nil)
    end
  end

  context 'example two' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'cats@cathouse.com'
          u.role = 'Homes England'
        end
      )
    end

    it 'returns a role for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user.role).to eq('Homes England')
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

    it 'updates the user' do
      new_user_id
      user_to_update = gateway.find_by(email: 'cats@cathouse.com')
      user_to_update.projects = [1, 4, 1, 5, 9]
      user_to_update.role = 'Superuser'
      gateway.update(user_to_update)
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user.projects).to eq([1, 4, 1, 5, 9])
      expect(user.role).to eq('Superuser')
    end

    it 'gets multiple users' do
      user_one = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'dogs@doghouse.com'
        u.role = 'Local Authority'
        u.projects = [6]
      end
      user_two = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'moo@cowhouse.com'
        u.role = 'Homes England'
        u.projects = [6]
      end
      user_three = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'cow@cowhouse.com'
        u.role = 'Homes England'
        u.projects = [7, 8]
      end
      user_one.id = gateway.create(
        user_one
      )
      user_two.id = gateway.create(
        user_two
      )
      user_three.id = gateway.create(
        user_three
      )

      users = gateway.get_users(project_id: 6)
      expect(users.length).to eq(2)
      expect(users[0].email).to eq('dogs@doghouse.com')
      expect(users[0].role).to eq('Local Authority')
      expect(users[1].email).to eq('moo@cowhouse.com')
      expect(users[1].role).to eq('Homes England')
    end

    it 'deletes a user' do
      new_user_id
      user_to_delete = gateway.find_by(email: 'cats@cathouse.com')
      gateway.delete_user('cats@cathouse.com')
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user).to eq(nil)
    end
  end

  context 'with mixed case emails' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'CatsCatsCats@cathouse.com'
        end
      )
    end

    before { new_user_id }

    it 'Finds the email correctly' do
      found_user = gateway.find_by(email: 'CATSCATSCATS@cathouse.com')
      expect(found_user.id).to eq(new_user_id)
      expect(found_user.email).to eq('CatsCatsCats@cathouse.com')
    end
  end
end
