class AccountsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      flash[:success] = "New account created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def show
    @account = current_user.accounts.update(account_params)
  end
  def destroy
  end

  private

    def account_params
      params.require(:account).permit(:total)
    end

end
