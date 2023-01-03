class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :login]
  before_action :set_user, only: [:update, :show, :destroy]

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer, status: :ok
  end

  def show
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  def create
    # byebug
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      user = UserSerializer.new(user).serializable_hash
      user['token'] = token
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    byebug
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: {message: 'User Delete Succesfully'}, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by_email(params[:user][:email])
    if @user&.authenticate(params[:user][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def set_user
    byebug
    @user = User.find_by_id(params[:id])
    return if @user.present?
    render json: {message: 'User Not Found'}
  end

  def user_params
    #byebug
    params.require(:user).permit(:username, :first_name, :last_name, :email, :age, :password, :password_confirmation)
  end
end
