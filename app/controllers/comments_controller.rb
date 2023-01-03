class CommentsController < ApplicationController
   before_action :authorize_request
   before_action :set_comment, only: [:update, :show, :destroy]

  def index
    # byebug
    @comments = Comment.find_by(id: params[:comment_id])&.comments
    render json: @comments, each_serializer: CommentSerializer, status: :ok
  end

  def show
      render json: @comment, each_serializer: CommentsController, status: :ok
  end

  def create
    #byebug 
    @comment = @current_user.comments.new(comment_params)
    if @comment.save
      render json: CommentSerializer.new(@comment).serializable_hash, status: :created
    else
      render json: {errors: @comment.errors}
    end
  end

  def update
    if @comment.update(comment_params)
      render json: CommentSerializer.new(@comment).serializable_hash
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
   if @comment.destroy
      render json: {message: "Comment deleted "}
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_comment
   @comment = Comment.find_by_id(params[:id])
    render json: {message: "comment Not Found "} unless @comment.present?
  end

  def comment_params
    params.require(:comment).permit(:comment, :commentable_id,:commentable_type)
  end

end