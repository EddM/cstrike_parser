class Attack
  include DataMapper::Resource

  Expression = Regexp.new('.*?<[^>]+>(<[^>]+>).*?(attacked).*?<[^>]+>.*?(<[^>]+>).*?(with).*?(".*?").*?(damage).*?(".*?").*?(damage_armor).*?(".*?").*?(health).*?(".*?").*?(armor).*?(".*?")', Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :damage, Integer
  property :armour_damage, Integer
  property :hp_remaining, Integer
  property :armour_remaining, Integer
  property :headshot, Boolean
  property :weapon, Enum[ :knife, :grenade, :usp, :glock18, :deagle, :ak47, :m4a1, :famas, :galil, :aug, :sg552, :scout, :awp, :sg550, :g3sg1, :mp5, :ump45, :p90, :mac10, :tmp, :p228, :fn57, :elites, :m3, :xm1014, :m249 ]

  belongs_to :victim, 'Player'
  belongs_to :player
  belongs_to :round

end