# frozen_string_literal: true

class LocalAuthority::Gateway::SequelUsers
  def initialize(database:)
    @database = database
  end

  def find_by(email:)
    user = @database[:users].all.find { |u| u[:email].casecmp?(email) }
    return nil if user.nil?

    LocalAuthority::Domain::User.new.tap do |u|
      u.id = user[:id]
      u.email = user[:email]
      u.role = user[:role]
      u.projects = []
      u.projects = user[:projects].to_a unless user[:projects].nil?
    end
  end

  def create(user)
    if user.projects.nil?
      @database[:users].insert(
        email: user.email,
        role: user.role
      )
    else
      @database[:users].insert(
        email: user.email,
        role: user.role,
        projects: Sequel.pg_array(user.projects)
      )
    end
  end

  def update(user)
    @database[:users]
      .where(email: user.email)
      .update(projects: Sequel.pg_array(user.projects), role: user.role)
  end

  def get_users(project_id:)
    @database[:users].all.select { |user| user[:projects]&.include?(project_id) }.map do |user|
      LocalAuthority::Domain::User.new.tap do |u|
        u.id = user[:id]
        u.email = user[:email]
        u.role = user[:role]
        u.projects = []
        u.projects = user[:projects].to_a unless user[:projects].nil?
      end
    end
  end

  def delete_user(email)
    @database[:users].where(email: email).delete
  end
end
