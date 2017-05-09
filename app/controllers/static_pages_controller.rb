class StaticPagesController < ApplicationController
  def home
  end
  def about
  end
  def new_account
    if logged_in?
      @account = current_user.accounts.build
    else
      redirect_to root_url
    end
  end
  private

    def account_params
      params.permit(:total, :id)
    end

end
