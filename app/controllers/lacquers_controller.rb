class LacquersController < ApplicationController
  autocomplete :lacquer, :name

  def autocomplete_name
    @lacquers = Lacquer.order(:name).where('lower(name) LIKE ?', "#{params[:term].downcase}%").limit(10)
    respond_to do |format|
      format.json { render json: @lacquers.map(&:name) }
    end
  end

  def create
    @user = current_user
    lacquer = Lacquer.new(name: params[:lacquer][:name], brand_id: params[:lacquer][:brand_id])
    lacquer.user_added_by_id = params[:lacquer][:user_added_by_id] if params[:lacquer][:user_added_by_id]
    lacquer.save
    if lacquer.errors.any?
      flash[:error] = lacquer.errors.full_messages.to_sentence
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
    @lacquer = Lacquer.includes(:reviews, :swatches).find(params[:id])
  end

  def edit
    session[:originated_from_uri] = request.env["HTTP_REFERER"] if request.env["HTTP_REFERER"]
    if !current_user
      flash[:alert] = "You must be signed in to edit a lacquer!"
      redirect_to root_path
    else
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
  end

  def update
    @user = current_user
    @lacquer = Lacquer.find(params[:id])
    @user_lacquer = UserLacquer.find(params[:lacquer][:user_lacquer_id])

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
        @lacquer.update(lacquer_params)
        @user_lacquer.update(user_lacquer_params[:user_lacquers_attributes]["0"])

        flash[:notice] = "#{@lacquer.name} successfully updated!"
        if session[:originated_from_uri]
          redirect_uri = session[:originated_from_uri]
          session[:originated_from_uri] = nil
          redirect_to redirect_uri
        else 
          redirect_to lacquer_path(@review.lacquer)
        end
      end
    end
  end

  def search
    @search_term = params[:search_term]
    @results = Lacquer.fuzzy_find_by_name(@search_term).uniq
    render :search_results
  end

  private
    def lacquer_params
      params.require(:lacquer).permit(:swatches_attributes => [:image, :user_id, :delete_image], :reviews_attributes => [:rating, :comments, :user_id])
    end

    def user_lacquer_params
      params.require(:lacquer).permit(:user_lacquers_attributes => [:selected_display_image, :color_ids => [], :finish_ids => []])
    end

end
