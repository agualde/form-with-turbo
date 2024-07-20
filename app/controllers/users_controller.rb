class UsersController < ApplicationController
  def index
    @users = User.all
    @cities = User.distinct.pluck(:city)

    if params[:city].present?
      @users = @users.where(city: params[:city])
    end
    
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.append('user-table', partial: 'user_row', locals: { user: @user }),
            turbo_stream.replace('new_user_form', partial: 'form', locals: { user: User.new })
          ]
        }
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace('new_user_form', partial: 'form', locals: { user: @user })
        }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :city, :telephone_number)
  end
end
