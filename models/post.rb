class Post < ActiveRecord::Base
	  def tags
    self.body.scan(/#(\w+)/).flatten
  end
end