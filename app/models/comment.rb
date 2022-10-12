class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  def commented_by
    self.user.slice(:id, :first_name, :last_name)
  end
end
