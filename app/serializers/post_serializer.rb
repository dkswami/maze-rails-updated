class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :updated_at

  has_many :comments
end
