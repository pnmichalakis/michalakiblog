class User < ActiveRecord::Base
  include BCrypt

  def password
    # this is not an actual hash
    @password ||= Password.new(self.password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
