class BombDefusal
  include DataMapper::Resource

  Expression = Regexp.new('.*?<[^>]+>(<[^>]+>).*?(Begin).*?(Bomb).*?(Defuse).*?(Without|With).*?(Kit)', Regexp::IGNORECASE)
  SuccessfulExpression = Regexp.new('.*?<[^>]+>(<[^>]+>).*?(triggered).*?("Defused_The_Bomb")', Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :with_kit, Boolean
  property :successful, Boolean

  belongs_to :player
  belongs_to :round
  
end