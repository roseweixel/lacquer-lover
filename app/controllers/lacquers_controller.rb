class LacquersController < ApplicationController
  def index
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = User.new
    end
  end

  def create
    @user = current_user
    lacquer = Lacquer.new(name: params[:lacquer][:name], brand_id: params[:lacquer][:brand_id])
    lacquer.user_added_by_id = params[:lacquer][:user_added_by_id] if params[:lacquer][:user_added_by_id]
    lacquer.save
    if lacquer.errors.any?
      lacquer.errors.messages.each do |message|
        flash[:notice] = message
      end
    else
      if params[:user_lacquer]
        @user_lacquer = lacquer.user_lacquers.create(user_id: current_user.id)
        params[:user_lacquer][:color_ids].each do |color_id|
          if color_id != ""
            @user_lacquer.colors.push(Color.find(color_id))
          end
        end
        params[:user_lacquer][:finish_ids].each do |finish_id|
          if finish_id != ""
            @user_lacquer.finishes.push(Finish.find(finish_id))
          end
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js { }
    end
  end

  def show
    @lacquer = Lacquer.find(params[:id])
  end

  def edit
    @user = current_user
    @lacquer = Lacquer.find(params[:id])
    if params[:user_lacquer_id] && UserLacquer.find(params[:user_lacquer_id])
      @user_lacquer = UserLacquer.find(params[:user_lacquer_id])
      if @user_lacquer.user_id != @user.id
        flash[:alert] = "You cannot edit a lacquer that is not in your collection!"
        redirect_to root_path
      end
    elsif !UserLacquer.where(user_id: @user.id, lacquer_id: @lacquer.id).empty?
      @user_lacquer = UserLacquer.where(user_id: @user.id, lacquer_id: @lacquer.id).first
    else
      flash[:alert] = "You cannot edit a lacquer that is not in your collection!"
      redirect_to root_path
    end
    if @user_lacquer
      session[:user_lacquer_id] = params[:user_lacquer_id] || @user_lacquer.id
      @swatch = Swatch.new
    end
  end

  def update
    @user = current_user
    @lacquer = Lacquer.find(params[:id])
    @user_lacquer = UserLacquer.find(session[:user_lacquer_id])

    if @lacquer.user_added_by_id != @user.id && params[:lacquer][:name] || params[:lacquer][:brand_id]
      flash[:alert] = "You do not have permission to change the name or brand of this lacquer."
      redirect_to(:back)
    else
      if @lacquer.user_added_by_id == @user.id && params[:lacquer][:name]
        @lacquer.update(name: params[:lacquer][:name])
      end
      if current_user.id != @user_lacquer.user_id && (params[:lacquer][:user_lacquer])
        flash[:alert] = "You can only change color or finish tags for your own lacquers."
        redirect_to(:back)
      else
        @user_lacquer.finishes.clear
        @user_lacquer.colors.clear
        @user_lacquer.save
        @lacquer.update(lacquer_params)
        if params[:lacquer][:user_lacquer] && params[:lacquer][:user_lacquer][:color_ids] && params[:lacquer][:user_lacquer][:color_ids] != [""]
          #binding.pry
          params[:lacquer][:user_lacquer][:color_ids].each do |color_id|
            if color_id != ""
              @user_lacquer.colors.push(Color.find(color_id))
            end
          end
        end
        if params[:lacquer][:user_lacquer] && params[:lacquer][:user_lacquer][:finish_ids] && params[:lacquer][:user_lacquer][:finish_ids] != [""]
          params[:lacquer][:user_lacquer][:finish_ids].each do |finish_id|
            if finish_id != ""
              @user_lacquer.finishes.push(Finish.find(finish_id))
            end
          end
        end
        flash[:notice] = "#{@lacquer.name} successfully updated!"
        redirect_to(:back)
      end
    end
  end

  def search
    @search_term = params[:search_term]
    # @results = Lacquer.lacquers_matching_all_words(params[:search_term])
    # if @results.empty?
    #   @results = Lacquer.lacquers_matching_most_words(params[:search_term])
    # end
    # if @results.empty?
    #   binding.pry
    #   @results = Lacquer.closest_lacquers(params[:search_term])
    # end
    @results = Lacquer.fuzzy_find_by_name(@search_term).uniq
    render :search_results
  end

  private
    def lacquer_params
      params.require(:lacquer).permit(:swatches_attributes => [:image, :user_id, :delete_image])
    end

end
