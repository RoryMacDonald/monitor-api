class LocalAuthority::Gateway::SequelUsers
  def initialize(database:)
    @database = database
  end

  def find_by(email:)
    user = @database[:users].first(email: email)
    return nil if user.nil?

    LocalAuthority::Domain::User.new.tap do |u|
      u.id = user[:id]
      u.projects = []
      u.projects = user[:projects] unless user[:projects].nil?
    end
  end

  def create(user)
    if user.projects.nil?
      @database[:users].insert(
        email: user.email
      )
    else
      @database[:users].insert(
        email: user.email,
        projects: Sequel.pg_array(user.projects)
      )
    end
  end
end
