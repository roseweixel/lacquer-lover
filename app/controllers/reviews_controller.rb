class ReviewsController < ApplicationController
  def destroy
    review = Review.find(params[:id])
    flash[:info] = "Your review for #{review.lacquer.name} has been deleted."
    review.destroy
    redirect_to :back
  end
end
