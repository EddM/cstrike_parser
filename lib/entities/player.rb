class Player
  include DataMapper::Resource
  
  property :id, String, :key => true
  
  has n, :messages
  has n, :kills
  has n, :attacks
  has n, :bomb_defusals
  has n, :bomb_plants
  
end