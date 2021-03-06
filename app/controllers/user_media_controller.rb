class UserMediaController < ApplicationController

  def create
    @medium = Medium.find_by_name(params[:medium][:name])

    if @medium
      medium_id = @medium.id
    else
      @medium = Medium.create(params[:medium])
      medium_id = @medium.id
    end

    @user_medium = UserMedium.new(medium_id: medium_id, user_id: current_user.id)

    @user_medium.save

    if @user_medium.persisted? && request.xhr?
      render partial: "user_media/um", locals: {medium: @medium, user: current_user}
    else
      redirect_to edit_user_url(current_user)
    end
  end

  def destroy
    @user_medium = UserMedium.find(params[:id])
    @user_medium.destroy
    redirect_to edit_user_url(current_user)
  end

end
