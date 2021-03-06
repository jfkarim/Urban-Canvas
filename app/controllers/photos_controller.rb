class PhotosController < ApplicationController

  def index
    @user = User.includes(:photos).find(params[:user_id])
    @photos = Photo.where(user_id: params[:user_id])
    render :index
  end

  def create
    @user = User.find(params[:user_id])
    params[:photo][:user_id] = params[:user_id]

    @photo = Photo.new(params[:photo])
    @photo.lat_lng if params[:location]

    @photo.save

    if @photo.album_id.nil?
      redirect_to user_photo_url(@user, @photo)
    else
      redirect_to user_album_url(@user, Album.find(@photo.album_id))  #ERROR HANDLING NEEDED
    end
  end

  def edit
    @user = User.includes(:photos).find(params[:user_id])
    @photo = Photo.find(params[:id])
    render :edit
  end

  def update
    @user = User.includes(:photos).find(params[:user_id])

    @photo = Photo.find(params[:id])
    @photo.location = (params[:photo][:location])
    @photo.lat_lng
    @photo.update_attributes(params[:photo])

    if request.xhr?
      render partial: "albums/edit_photo_show_info", locals: {user: @user, photo: @photo}
    else
      redirect_to user_photo_url(@user, @photo)  #ERROR HANDLING NEEDED
    end
  end

  def show
    @user = User.includes(:photos).find(params[:user_id])
    @photo = Photo.find(params[:id])
    render :show
  end

  def destroy
    @user = User.includes(:photos).find(params[:user_id])
    @photo = Photo.find(params[:id])
    @photo.destroy
    render json: @photo
  end

end
