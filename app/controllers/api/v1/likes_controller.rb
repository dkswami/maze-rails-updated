module Api
  module V1
    class LikesController < ApiController
      before_action :doorkeeper_authorize!
      before_action :current_user
      protect_from_forgery with: :null_session
      respond_to :json

      def create
        @like = Like.create(user_id: current_user.id, post_id: params[:post_id])

        if @like.save
          render json: @like
        else
          render json: { error: @like.errors.messages }, status: 422
        end
      end

      def delete_like
        @like = Like.find_by(post_id: params[:post_id])

        if @like.destroy
          head :no_content
        else
          render json: { error: @like.errors.messages }, status: 422
        end

        # if !(already_liked?)
        #   render json: { error: "Cannot unlike" }, status: 422
        # else
        #   @like.destroy
        #   head :no_content
        # end
      end


      private

      def already_liked?
        Like.where(user_id: current_user.id, post_id:
          params[:post_id]).exists?
      end

      def like_params
          params.permit(:post_id, :user_id)
      end
    end
  end
end