class Game < ApplicationRecord
  belongs_to :amount_of_work
  belongs_to :complexity
  belongs_to :unknown_risk
  has_many :games_players
end
