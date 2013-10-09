class UsersController < ApplicationController
  before_filter :require_current_user!, :only => [:show]
  before_filter :require_no_current_user!, :only => [:create, :new]

  def index
    @users = User.all
    # render json: @users.to_json(include: [:influences, :themes, :media])
    redirect_to users_url
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    @user = User.new
    render :new
  end

  def show
    if params.include?(:id)
      @user = User.includes(:locations, :influences, :media, :themes).find(params[:id])
      render :show
    else
      redirect_to user_url(current_user)
    end
  end

  def edit
    @user = User.includes(:locations, :influences, :media, :themes).find(params[:id])
    render :edit
  end

  def update
    @user = User.includes(:locations, :influences, :media, :themes).find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :edit
    end
  end

end