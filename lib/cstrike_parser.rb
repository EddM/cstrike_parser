require 'rubygems'
require 'data_mapper'

require 'helpers/expressions'

require 'entities/event'
require 'entities/player'
require 'entities/round'
require 'entities/session'
require 'entities/events/attack'
require 'entities/events/bomb_defusal'
require 'entities/events/bomb_plant'
require 'entities/events/kill'
require 'entities/events/message'

class CStrikeParser
  include Helpers::Expressions

  attr_reader :log_file, :sessions

  def initialize(log_file)
    @log_file = File.open(log_file)
    @sessions = []
  
    setup_data_mapper
  end

  def parse!
    @current_session = nil
    @current_round = nil
    
    defusal = nil
  
    @log_file.each_line do |line|
      next if line[0..0] == '#' # for comments
      
      if @current_session        
        if m = line.match(TimestampExpression)
          m.to_a.map { |match| match.to_i }
          timestamp = Time.mktime(m[6], m[2], m[4], m[8], m[10], m[12])
        else
          next # malformed log entry
        end
      
        message = parse_message(line, timestamp)
        attack = parse_attack(line, timestamp)
        kill = parse_kill(line, timestamp)
        plant = parse_bomb_plant(line, timestamp)
        defusal = parse_bomb_defusal(line, timestamp, defusal)
        parse_bomb_defusal_success(line, defusal) if defusal
    
        if m = line.match(Round::Expression)
          defusal = nil
          @current_round = @current_session.rounds.create
        end
      else
        if line =~ SessionExpression
          @current_session = Session.create
          @current_round = @current_session.rounds.create
        end
      end
    
    end
  
    @sessions << @current_session if @current_session
  end

  private

  def parse_message(line, timestamp)
    if m = line.match(Message::Expression)
      player = @current_session.players.first_or_create(:id => m[1])
      @current_round.messages.create(:timestamp => timestamp, :round => @current_round, :player => player, :contents => m[3][1..-2], :private => m[2] == "say_team", :alive => m[4] != " (dead)")
    end
  end

  def parse_attack(line, timestamp)
    if m = line.match(Attack::Expression)
      player = @current_session.players.first_or_create(:id => m[1])
      victim = @current_session.players.first_or_create(:id => m[3])
      dmg = m[7][1..-2].to_i
      armour_dmg = m[9][1..-2].to_i
      health = m[11][1..-2].to_i
      armour = m[13][1..-2].to_i
  
      @current_round.attacks.create(:timestamp => timestamp, :round => @current_round, :player => player, :victim => victim, :weapon => m[5][1..-2].to_sym, :damage => dmg, :armour_damage => armour_dmg, :hp_remaining => health, :armour_remaining => armour, :headshot => dmg > 100)
    end
  end

  def parse_kill(line, timestamp)
    if m = line.match(Kill::Expression)
      player = @current_session.players.first_or_create(:id => m[1])
      victim = @current_session.players.first_or_create(:id => m[3])
      @current_round.kills.create(:timestamp => timestamp, :round => @current_round, :player => player, :victim => victim, :weapon => m[5][1..-2].to_sym)
    end
  end

  def parse_bomb_plant(line, timestamp)
    if m = line.match(BombPlant::Expression)
      player = @current_session.players.first_or_create(:id => m[1])
      @current_round.bomb_plants.create(:timestamp => timestamp, :round => @current_round, :player => player)
    end
  end

  def parse_bomb_defusal(line, timestamp, defusal)
    if m = line.match(BombDefusal::Expression)
      player = @current_session.players.first_or_create(:id => m[1])
      @current_round.bomb_defusals.create(:timestamp => timestamp, :round => @current_round, :player => player, :successful => false, :with_kit => m[5] == "With")
    else
      defusal
    end
  end

  def parse_bomb_defusal_success(line, defusal)
    if m = line.match(BombDefusal::SuccessfulExpression)
      defusal.successful = true && defusal.save
    end
  end

  def setup_data_mapper
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, 'sqlite::memory:')
    DataMapper::Model.raise_on_save_failure = true 
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

end