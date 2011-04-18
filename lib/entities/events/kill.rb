class Kill
  include DataMapper::Resource

  Expression = Regexp.new('.*?<[^>]+>(<[^>]+>).*?(killed).*?<[^>]+>.*?(<[^>]+>).*?(with).*?(".*?")', Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :weapon, Enum[ :knife, :grenade, :usp, :glock18, :deagle, :ak47, :m4a1, :famas, :galil, :aug, :sg552, :scout, :awp, :sg550, :g3sg1, :mp5, :ump45, :p90, :mac10, :tmp, :p228, :fn57, :elites, :m3, :xm1014, :m249 ]

  belongs_to :player
  belongs_to :round
  belongs_to :victim, 'Player'
  
end