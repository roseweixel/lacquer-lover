class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  def new
    @lacquer = Lacquer.find(params[:lacquer_id])
    @review = @lacquer.reviews.build
    if request.env["HTTP_REFERER"]
      session[:originated_from_uri] = request.env["HTTP_REFERER"]
    end
  end

  def create
    @review = Review.create(review_params)
    if session[:originated_from_uri]
      redirect_to session[:originated_from_uri]
    else
      redirect_to lacquer_path(@review.lacquer)
    end
  end

  def destroy
    if current_user && current_user.id == @review.user_id
      flash[:notice] = "Your review for #{@review.lacquer.name} has been deleted."
      @review.destroy
      redirect_to :back
    elsif !current_user
      flash[:alert] = "You must be signed in to delete a review!"
      redirect_to root_path
    else
      flash[:alert] = "The review could not be deleted at this time!"
      redirect_to root_path
    end
  end

  def edit
    if request.env["HTTP_REFERER"]
      session[:originated_from_uri] = request.env["HTTP_REFERER"]
    end
    if !current_user
      flash[:alert] = "You must be signed in to edit a review!"
      redirect_to_originated_from_or_root
    else
      if @review.user.id != current_user.id
        flash[:warning] = "You cannot edit a review you didn't create!"
        redirect_to_originated_from_or_root
      end
    end
    respond_to do |f|
      f.html
      f.js
    end
  end

  def update
    if current_user && @review.user.id == current_user.id
      if @review.update(review_params)
        flash[:notice] = "Your review for #{@review.lacquer.name} was successfully updated!"
      else
        flash.now[:error] = @review.errors.full_messages.to_sentence
        render :edit and return true
      end
      if session[:originated_from_uri]
        redirect_uri = session[:originated_from_uri]
        session[:originated_from_uri] = nil
        redirect_to redirect_uri
      else 
        redirect_to lacquer_path(@review.lacquer)
      end
    elsif !current_user
      flash[:alert] = "You must be signed in to edit a review!"
      redirect_to_originated_from_or_root
    else
      flash[:warning] = "You cannot make changes to a review you didn't write!"
      redirect_to_originated_from_or_root
    end
  end

  private
    def review_params
      params.require(:review).permit(:rating, :comments, :user_id, :lacquer_id)
    end

    def set_review
      @review = Review.find(params[:id])
    end
end
