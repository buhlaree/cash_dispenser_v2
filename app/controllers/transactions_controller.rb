
class TransactionsController < ApplicationController
  def new
    @user = current_user
    @options = @user.accounts.all.collect do |account|
      ['Account Number ' + account.id.to_s + '  |  ' \
        "$#{account.total} available", account.id]
      end
    end

    def show
      @user = current_user
      @transaction = Transaction.find(params[:id])
      @transaction_hash = if @transaction.amount.to_i > 1
         { bills: 0 } # Dummy hash value for view
      else
        dispense(@transaction.amount.to_i.abs)
      end
    end

    def create
      Transaction.transaction do
        @dispenser = Dispenser.find(1)
        @total_available = 0
        @dispenser.attributes.to_options.each do |key, value|
          unless key == :id || key == :created_at || key == :updated_at
            @total_available += key.to_s.to_i * value
          end
        end
        @transaction = Transaction.create!(transaction_params)
        if @transaction.amount.to_i + @transaction.account.total.to_i < 0
          flash[:danger] = 'Insufficient Funds'
          redirect_to new_transaction_path and return
        elsif @total_available < @transaction.amount.to_i.abs
          flash[:danger] = 'Not enough cash to dispense'
          redirect_to root_url and return
        else
          @transaction.account.update_attribute(:total, @transaction.account.total.to_i + @transaction.amount.to_i)
          flash[:success] = 'Account Updated!'
        end
        redirect_to @transaction
      end
    end

    private

    def transaction_params
      params.require(:transaction).permit(:amount, :account_id)
    end

    def dispense(original_request)
      bills = {}
      transaction_hash = {}
      bills_available = {}
      @dispenser = Dispenser.find(1)
      @dispenser.attributes.to_options.each do |key, value|
        unless key == :id || key == :created_at || key == :updated_at
          bills_available[key.to_s.to_i] = value
        end
      end
      transaction_hash[:original_request] = original_request
      left_over = bills_available
      bills_available.each do |bill_type, number_available|
        number_needed = original_request / bill_type
        if number_available.zero?
          bills[bill_type] = 0
        elsif number_needed <= number_available
          bills[bill_type] = number_needed
          original_request -= bill_type * number_needed
          left_over[bill_type] = number_available - number_needed
        else
          actual = number_available
          bills[bill_type] = actual
          original_request -= (bill_type * actual)
          left_over[bill_type] = 0
        end
      end
      transaction_hash[:bills] = bills
      transaction_hash[:remainder] = original_request
      transaction_hash[:left_over] = left_over
      puts transaction_hash
      if original_request == 0
        @dispenser.update_attributes!(left_over)
      end
      puts "--------------"
      pp @dispenser.attributes.to_options
      puts "--------------"
      puts "**************"
      pp transaction_hash
      puts "**************"

      transaction_hash
    end
 end
