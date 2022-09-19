class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :body, :post_id, :updated_at
end
