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
  
  has n, :players, :through => :session
  
  def event_count
    Message.count(:round => self) +
    Attack.count(:round => self) +
    Kill.count(:round => self) +
    BombDefusal.count(:round => self) +
    BombPlant.count(:round => self)
  end
  
end