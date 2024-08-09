class UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :asc)
    @user = User.new
    @search_term = params[:search_term]

    filter_by_city if @search_term.present?

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('user_table', partial: 'user_table', locals: { users: @users })
        ]
      end
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @users = User.all.order(created_at: :asc)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('user_table', partial: 'user_table', locals: { users: @users }),
            turbo_stream.replace('new_user_form', partial: 'form', locals: { user: User.new })
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_user_form', partial: 'form', locals: { user: @user })
        end
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  def reset
    ResetUsersToInitialStateService.call

    redirect_to users_path, notice: 'Test successfully reset.'
  end

  private

  def filter_by_city
    columns = %w[city name email telephone_number]
    conditions = columns.map { |column| "#{column} LIKE ?" }.join(" OR ")
    values = Array.new(columns.size, "%#{@search_term}%")

    @users = @users.where(conditions, *values)
  end

  def user_params
    params.require(:user).permit(:name, :email, :city, :telephone_number)
  end
end
