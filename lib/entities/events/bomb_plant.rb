class BombPlant
  include DataMapper::Resource
  
  Expression = Regexp.new('.*?'+'<[^>]+>'+'(<[^>]+>)'+'.*?'+'(triggered "Planted_The_Bomb")', Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime

  belongs_to :player
  belongs_to :round
  
end