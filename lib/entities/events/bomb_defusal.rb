class BombDefusal
  include DataMapper::Resource

  Expression = Regexp.new('.*?<[^>]+>(<STEAM_[^>]+>).*?(Begin).*?(Bomb).*?(Defuse).*?(Without|With).*?(Kit)', Regexp::IGNORECASE)
  
  re1='.*?'	# Non-greedy match on filler
  re2='<[^>]+>'	# Uninteresting: tag
  re3='(<STEAM_[^>]+>)'	# Tag 1
  re4='.*?'	# Non-greedy match on filler
  re5='(triggered)'	# Word 1
  re6='.*?'	# Non-greedy match on filler
  re7='("Defused_The_Bomb")'	# Double Quote String 1

  re=(re1+re2+re3+re4+re5+re6+re7)
  
  SuccessfulExpression = Regexp.new(re,Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :with_kit, Boolean
  property :successful, Boolean

  belongs_to :player
  belongs_to :round
  
  def self.successful
    all(:successful => true)
  end
  
  def self.with_kit
    all(:with_kit => true)
  end
  
  def self.without_kit
    all(:with_kit => false)
  end
  
end