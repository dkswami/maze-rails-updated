module Api
  module V1
    class PostsController < ApplicationController
      before_action :doorkeeper_authorize!
      before_action :current_user
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        posts = Post.all
        # user = User.find_by(posts.user_id)
        render json: posts.as_json(include: [:comments], methods: :created_by)
        # posts.as_json(include: {  method: :created_by })

        # posts.as_json( include: { created_by: { include: { user: }}})
        # .to_json(include: {created_by: { include: :user}})
        # PostSerializer.new(posts, options).serialized_json
        # posts.to_json(include: { book: { include: :user } })
      end

      def show
        post = Post.find(params[:id])
        # render json: post.to_json(include: :comments)
        render json: {
          id: post.id,
          title: post.title,
          description: post.description,
          updated_at: post.updated_at.iso8601,
          post_status: post.post_status,
          created_by: {
            user_id: post.user_id,
            first_name: post.user.first_name,
            last_name: post.user.last_name
          },
          comments: post.comments
        }, status: :ok
      end

      def create
        post = Post.new(post_params)

        if post.save
          render json: post.to_json(include: :comments)
        else
          render json: { error: post.errors.messages }, status: 422
        end
      end

      def update
        post = Post.find(params[:id])

        if post.update(post_params)
          render json: post.to_json(include: :comments)
        else
          render json: { error: post.errors.messages }, status: 422
        end
      end

      def destroy
        post = Post.find(params[:id])

        if post.destroy
          head :no_content
        else
          render json: { error: post.errors.messages }, status: 422
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :description, :user_id, :post_status)
      end

      def post_by
        @post_by ||= { include: %i[user] }
      end

      def option
        @option ||= { include: %i[user] }
      end
    end
  end
end