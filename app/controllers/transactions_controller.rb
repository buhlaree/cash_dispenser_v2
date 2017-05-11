class TransactionsController < ApplicationController
  def new
    @user = current_user
    @options =  @user.accounts.all.collect do |account|
                ["Account Number " + "#{account.id}" + "  |  " +
                   "$#{account.total} available" , account.id]
                 end
  end

  def show
    @user = current_user
    @transaction = Transaction.find(params[:id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    Transaction.transaction do
      @transaction.save!
        if @transaction.deposit
          @transaction.account.update_attribute(:total,
                    @transaction.account.total.to_i + @transaction.amount.to_i)
        else
          @transaction.account.update_attribute(:total,
                    @transaction.account.total.to_i - @transaction.amount.to_i)
        end
    end

    dispense(@transaction.amount.to_i)
    redirect_to @transaction
  end

  private
    def transaction_params
      params.require(:transaction).permit(:amount, :account_id, :deposit)
    end

    def dispense(original_request)
      cash_symbol = CONFIG["CASHSYMBOL"]
      bills_available = CONFIG["BILLS"]
            bills = {}
            session_hash = {}
            session_hash[:original_request] = original_request
            left_over = bills_available

            bills_available.each do |bill_type, number_available|
              bills[bill_type] = 0
            end

            bills_available.each do |bill_type, number_available|
              number_needed = (original_request / bill_type)
              if number_available.zero?
                bills[bill_type] = 0
              elsif number_needed <= number_available
                bills[bill_type] = number_needed
                original_request -= (bill_type * number_needed)
                left_over[bill_type] = (number_available - number_needed)
              else
                actual = number_available
                bills[bill_type] = actual
                original_request -= (bill_type * actual)
                left_over[bill_type] = 0
              end
            end
            session_hash[:bills] = bills
            session_hash[:remainder] = original_request
            session_hash[:left_over] = left_over
            puts session_hash
    end
end
