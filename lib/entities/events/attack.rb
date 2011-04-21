class Attack
  include DataMapper::Resource
  
  re1='.*?'	# Non-greedy match on filler
  re2='<[^>]+>'	# Uninteresting: tag
  re3='(<STEAM_[^>]+>)'	# Tag 1
  re4='.*?'	# Non-greedy match on filler
  re5='((?:[a-z][a-z]+))'	# Word 1
  re6='.*?'	# Non-greedy match on filler
  re7='(attacked)'	# Word 2
  re8='.*?'	# Non-greedy match on filler
  re9='<[^>]+>'	# Uninteresting: tag
  re10='.*?'	# Non-greedy match on filler
  re11='(<STEAM_[^>]+>)'	# Tag 2
  re12='.*?'	# Non-greedy match on filler
  re13='((?:[a-z][a-z]+))'	# Word 3
  re14='.*?'	# Non-greedy match on filler
  re15='(with)'	# Word 4
  re16='.*?'	# Non-greedy match on filler
  re17='(".*?")'	# Double Quote String 1
  re18='.*?'	# Non-greedy match on filler
  re19='(damage)'	# Word 5
  re20='.*?'	# Non-greedy match on filler
  re21='(".*?")'	# Double Quote String 2
  re22='.*?'	# Non-greedy match on filler
  re23='(damage_armor)'	# Variable Name 1
  re24='.*?'	# Non-greedy match on filler
  re25='(".*?")'	# Double Quote String 3
  re26='.*?'	# Non-greedy match on filler
  re27='(health)'	# Word 6
  re28='.*?'	# Non-greedy match on filler
  re29='(".*?")'	# Double Quote String 4
  re30='.*?'	# Non-greedy match on filler
  re31='(armor)'	# Word 7
  re32='.*?'	# Non-greedy match on filler
  re33='(".*?")'	# Double Quote String 5

  re=(re1+re2+re3+re4+re5+re6+re7+re8+re9+re10+re11+re12+re13+re14+re15+re16+re17+re18+re19+re20+re21+re22+re23+re24+re25+re26+re27+re28+re29+re30+re31+re32+re33)
  Expression=Regexp.new(re,Regexp::IGNORECASE)
  
  property :id, Serial
  property :timestamp, DateTime
  property :damage, Integer
  property :armour_damage, Integer
  property :hp_remaining, Integer
  property :armour_remaining, Integer
  property :team, Boolean
  property :weapon, Enum[ :knife, :grenade, :usp, :glock18, :deagle, :ak47, :m4a1, :famas, :galil, :aug, :sg552, :scout, :awp, :sg550, :g3sg1, :mp5navy, :ump45, :p90, :mac10, :tmp, :p228, :fiveseven, :elite, :m3, :xm1014, :m249 ]

  belongs_to :victim, 'Player'
  belongs_to :player
  belongs_to :round
  belongs_to :kill, :required => false

  def headshot?
    damage > 100
  end

  def self.team
    all(:team => true)
  end

  def self.headshots
    all(:damage.gt => 100)
  end

end