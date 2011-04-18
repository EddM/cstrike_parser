class Round  
  include DataMapper::Resource

  Expression = Regexp.new('.*?(World triggered "Round_End")', Regexp::IGNORECASE)

  property :id, Serial

  belongs_to :session
  has n, :messages
  has n, :kills
  has n, :attacks
  has n, :bomb_defusals
  has n, :bomb_plants

end