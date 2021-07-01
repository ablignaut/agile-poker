# this will store the players in a game and their votes
class GamesPlayer < ApplicationRecord
  FIB_ARRAY = [0.1,0.5,1,2,3,5,8,13,20,40,100].freeze
  belongs_to :game

  scope :players_not_voted, -> { where(:complexity => nil, :amount_of_work => nil, :unknown_risk => nil) }

  def self.players_not_voted?
    players_not_voted.present?
  end

  def self.players_all_voted?
    return false if all.blank?

    !players_not_voted?
  end

  def voted?
    complexity && amount_of_work && unknown_risk
  end

  def self.sum_total_points
    @total_points ||= all.reject{|x| x.total_points.nil?}.sum(&:total_points)
  end

  def self.sum_fibonacci_vote
    @total_points ||= all.reject{|x| x.fibonacci_vote.nil?}.sum(&:fibonacci_vote)
  end

  def total_points
    @total_points ||= [complexity, amount_of_work, unknown_risk].compact.sum
  end

  # returns the vote that should be made according to the FIB_ARRAY
  # i.e. - the equivalent or next highest value
  def fibonacci_vote
    FIB_ARRAY.find_all{ |a| a >= total_points }.sort.first
  end

  def self.highest_voter
    total_points_ascending.last
  end

  def self.lowest_voter
    total_points_ascending.first
  end

  def self.total_points_ascending
    all.sort_by(&:total_points)
  end
end
