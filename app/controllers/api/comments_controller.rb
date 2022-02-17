class Api::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :validate_params_presence, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_error

  def create
    article = Article.find(params[:article_id])
    comment = current_user.comments.create(comment_params.merge(article: article))
    if comment.persisted?
      render json: { comment: comment }, status: :created
    end
  end

  private

  def validate_params_presence
    if params[:comment].nil?
      render_error('Comment param is missing', :unprocessable_entity)
    elsif params[:comment][:body].nil? || params[:comment][:body] == ''
      render_error("Comment body can't be empty", :unprocessable_entity)
    end
  end

  def render_error(message, status)
    render json: { message: message }, status: status
  end

  def render_404_error
    render json: { message: 'Article not found' }, status: :not_found
  end

  def comment_params 
    params[:comment].permit(:body)
  end
end
