class Player
  include DataMapper::Resource
  
  property :id, String, :key => true
  
  has n, :messages
  has n, :kills
  has n, :attacks
  has n, :bomb_defusals
  has n, :bomb_plants
  
  has n, :sessions, :through => Resource
  has n, :rounds, :through => :sessions
  
  def deaths
    Kill.all(:victim_id => id)
  end
  
  def ace_rounds
    round_ids = repository.adapter.select("SELECT rounds.id FROM rounds INNER JOIN kills ON kills.round_id = rounds.id WHERE kills.player_id = ? AND kills.team = 'f' GROUP BY kills.round_id, kills.player_id having count(kills.id) > 4", id)
    rounds.all(:conditions => ["rounds.id IN ?", round_ids])
  end
  
end