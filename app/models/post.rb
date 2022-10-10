class Post < ApplicationRecord
	has_many :comments, dependent: :destroy
	belongs_to :user

	def created_by
		self.user.slice(:id, :first_name, :last_name)
	end
end
