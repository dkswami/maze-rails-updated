module Api
	module V1
		class CommentsController < ApplicationController
			protect_from_forgery with: :null_session

			def create
				comment = Comment.new(comment_params)

				if comment.save
					render json: comment
				else 
					render json: { error: comment.errors.messages }, status: 422
				end
			end

			def update
				comment = Comment.find(params[:id])

				if comment.update(comment_params)
					render json: comment
				else
					render json: { error: comment.errors.messages }, status: 422
				end
			end

			def destroy
				comment = Comment.find(params[:id])

				if comment.destroy
					head :no_content
				else 
					render json: { error: comment.errors.messages }, status: 422
				end
			end				

			private
				def comment_params
					params.require(:comment).permit(:body, :post_id)
				end


		end
	end
end