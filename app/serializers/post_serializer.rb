class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description

  has_many :comments
end
