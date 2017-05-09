class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  accepts_nested_attributes_for :transactions
  validates :user_id, presence: true
  validates :total, presence: true, numericality: { only_integer: true }
  default_scope -> { order(created_at: :desc) }
end
