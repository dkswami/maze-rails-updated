class Post < ApplicationRecord
	has_many :comments, dependent: :destroy
	has_many :likes, dependent: :destroy
	belongs_to :user

	def created_by
		self.user.slice(:id, :first_name, :last_name)
	end
	def likes_count
		self.likes.count
	end
end
