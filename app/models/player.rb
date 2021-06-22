class Player
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :name, :complexity, :amount_of_work, :unknown_risk

  def attributes
    {'name' => nil, 'complexity' => nil, 'amount_of_work' => nil, 'unknown_risk' => nil}
  end

end