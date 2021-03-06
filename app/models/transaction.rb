class Transaction < ApplicationRecord
  belongs_to :account
  validates :account_id, presence: true
  validates :amount, presence: true, numericality: { only_integer: true }
  default_scope -> { order(created_at: :desc) }
end
