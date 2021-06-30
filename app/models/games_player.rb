# this will store the players in a game and their votes
class GamesPlayer < ApplicationRecord
  belongs_to :game

  scope :players_not_voted, -> { where(:complexity => nil, :amount_of_work => nil, :unknown_risk => nil) }

  def self.players_not_voted?
    players_not_voted.present?
  end

  def voted?
    complexity && amount_of_work && unknown_risk
  end
end
