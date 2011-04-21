class Session
  include DataMapper::Resource

  property :id, Serial
  property :started_at, DateTime
  property :ended_at, DateTime

  has n, :rounds
  has n, :players, :through => Resource
  
  def add_player(player)
    PlayerSession.create(:session => self, :player => player) unless PlayerSession.count(:player => player, :session => self) > 0
  end
  
end