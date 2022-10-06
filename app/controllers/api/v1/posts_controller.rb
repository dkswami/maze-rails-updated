module Api
	module V1
		class PostsController < ApplicationController
			before_action :doorkeeper_authorize!
			protect_from_forgery with: :null_session

			def index
				posts = Post.all
				render json:  posts.to_json(include: :comments)
								 # PostSerializer.new(posts, options).serialized_json
								 # posts.to_json(include: { book: { include: :user } })
			end

			def show
				post = Post.find(params[:id])
				render json: post.to_json(include: :comments)
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
					params.require(:post).permit(:title,:description)
				end

				def options
					@options ||= { include: %i[comments] }
				end
		end
	end
end