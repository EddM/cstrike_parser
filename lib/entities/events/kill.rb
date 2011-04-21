class Kill
  include DataMapper::Resource

  re1='.*?'	# Non-greedy match on filler
  re2='<[^>]+>'	# Uninteresting: tag
  re3='(<STEAM_[^>]+>)'	# Tag 1
  re4='(<[^>]+>)'	# Tag 2
  re5='.*?'	# Non-greedy match on filler
  re6='(killed)'	# Word 1
  re7='.*?'	# Non-greedy match on filler
  re8='<[^>]+>'	# Uninteresting: tag
  re9='.*?'	# Non-greedy match on filler
  re10='(<STEAM_[^>]+>)'	# Tag 3
  re11='(<[^>]+>)'	# Tag 4
  re12='.*?'	# Non-greedy match on filler
  re13='(with)'	# Word 2
  re14='.*?'	# Non-greedy match on filler
  re15='(".*?")'	# Double Quote String 1

  re=(re1+re2+re3+re4+re5+re6+re7+re8+re9+re10+re11+re12+re13+re14+re15)
  Expression = Regexp.new(re, Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :team, Boolean
  property :weapon, Enum[ :knife, :grenade, :usp, :glock18, :deagle, :ak47, :m4a1, :famas, :galil, :aug, :sg552, :scout, :awp, :sg550, :g3sg1, :mp5navy, :ump45, :p90, :mac10, :tmp, :p228, :fiveseven, :elite, :m3, :xm1014, :m249 ]

  belongs_to :player
  belongs_to :round
  belongs_to :victim, 'Player'
  
  def self.team
    all(:team => true)
  end
  
end