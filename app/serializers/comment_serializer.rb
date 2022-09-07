class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :body, :post_id
end
