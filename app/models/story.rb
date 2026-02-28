class Story < ApplicationRecord
  belongs_to :game

  STATUSES = %w[pending active estimated].freeze

  validates :issue_key, presence: true
  validates :status,   inclusion: { in: STATUSES }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered,   -> { order(:position, :created_at) }
  scope :pending,   -> { where(status: 'pending').ordered }
  scope :active,    -> { where(status: 'active') }
  scope :estimated, -> { where(status: 'estimated').ordered }
end
