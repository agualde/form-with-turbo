class UsersController < ApplicationController
  before_action :set_users_collection, only: %i[index destroy]

  def index
    @user = User.new

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('user_table', partial: 'user_table', locals: { users: @users }),
          turbo_stream.replace('new_user_form', partial: 'form', locals: { user: @user, search_term: @search_term })
        ]
      end
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      set_users_collection

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('user_table', partial: 'user_table', locals: { users: @users }),
            turbo_stream.replace('new_user_form', partial: 'form', locals: { user: User.new, search_term: @search_term })
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_user_form', partial: 'form', locals: { user: @user, search_term: @search_term })
        end
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('user_table', partial: 'user_table', locals: { users: @users })
        ]
      end
    end
  end

  def reset
    ResetUsersToInitialStateService.call
    set_users_collection

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('user_table', partial: 'user_table', locals: { users: @users })
        ]
      end
    end
  end

  private

  def set_users_collection
    @users = User.all.order(created_at: :asc)
    filter_users
  end

  def filter_users
    @search_term = params[:search_term]
    return unless @search_term.present?

    columns = %w[city name email telephone_number]
    conditions = columns.map { |column| "#{column} LIKE ?" }.join(" OR ")
    values = Array.new(columns.size, "%#{@search_term}%")

    @users = @users.where(conditions, *values)
  end

  def user_params
    params.require(:user).permit(:name, :email, :city, :telephone_number)
  end
end
