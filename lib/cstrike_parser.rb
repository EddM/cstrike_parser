require 'rubygems'
require 'data_mapper'
require 'dm-aggregates'

require 'helpers/expressions'

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

  def initialize(file = nil, db = "sqlite::memory:", log_level = :debug)
    @log_file = file ? File.open(file) : nil
    @db, @log_level, @sessions = db, log_level, []
  end

  def parse!
    @current_session = nil
    @current_round = nil
    
    defusal = nil
    killing_attack = nil
  
    @log_file.each_line do |line|
      next if line[0..0] == '#' # for comments
      
      begin
      
      if @current_session
        if m = line.match(TimestampExpression)
          m.to_a.map { |match| match.to_i }
          timestamp = Time.mktime(m[6], m[2], m[4], m[8], m[10], m[12])
        else
          next
        end
      
        message = parse_message(line, timestamp)
        attack = parse_attack(line, timestamp)
        kill = parse_kill(line, timestamp, killing_attack)
        plant = parse_bomb_plant(line, timestamp)
        defusal = parse_bomb_defusal(line, timestamp, defusal)
        parse_bomb_defusal_success(line, defusal) if defusal
        
        killing_attack = nil if killing_attack
        killing_attack = attack if attack && attack.hp_remaining <= 0
    
        if m = line.match(Round::Expression)
          defusal = nil
          @current_round.destroy if @current_round.event_count == 0
          @current_round = @current_session.rounds.create
        end
      else
        if line =~ SessionExpression
          @current_session = Session.create
          @current_round = @current_session.rounds.create
        end
      end
    
      rescue DataMapper::SaveFailureError => e
        puts e.resource.errors.inspect
      end
    
    end
  
    @sessions << @current_session if @current_session
  end

  private

  def parse_message(line, timestamp)
    if m = line.match(Message::Expression)
      player = Player.first_or_create(:id => m[1][1..-2])
      @current_session.add_player(player)
      @current_round.messages.create(:timestamp => timestamp, :round => @current_round, :player => player, :contents => m[3][1..-2], :private => m[2] == "say_team", :alive => m[4] != " (dead)")
    end
  end

  def parse_attack(line, timestamp)
    if m = line.match(Attack::Expression)
      player = Player.first_or_create(:id => m[1][1..-2])
      @current_session.add_player(player)
      victim = Player.first_or_create(:id => m[4][1..-2])
      @current_session.add_player(victim)
      dmg = m[9][1..-2].to_i
      armour_dmg = m[11][1..-2].to_i
      health = m[13][1..-2].to_i
      armour = m[15][1..-2].to_i
  
      @current_round.attacks.create(:timestamp => timestamp, :round => @current_round, :player => player, :victim => victim, :weapon => m[7][1..-2].to_sym, :damage => dmg, :armour_damage => armour_dmg, :hp_remaining => health, :armour_remaining => armour, :team => m[2] == m[5])
    end
  end

  def parse_kill(line, timestamp, killing_attack)
    if m = line.match(Kill::Expression)
      player = Player.first_or_create(:id => m[1][1..-2])
      @current_session.add_player(player)
      victim = Player.first_or_create(:id => m[4][1..-2])
      @current_session.add_player(victim)
      
      kill = @current_round.kills.create(:timestamp => timestamp, :round => @current_round, :player => player, :victim => victim, :weapon => m[7][1..-2].to_sym, :team => m[2] == m[5])
      
      if killing_attack
        killing_attack.kill = kill
        killing_attack.save
      end
    end
  end

  def parse_bomb_plant(line, timestamp)
    if m = line.match(BombPlant::Expression)
      player = Player.first_or_create(:id => m[1][1..-2])
      @current_session.add_player(player)
      @current_round.bomb_plants.create(:timestamp => timestamp, :round => @current_round, :player => player)
    end
  end

  def parse_bomb_defusal(line, timestamp, defusal)
    if m = line.match(BombDefusal::Expression)
      player = Player.first_or_create(:id => m[1][1..-2])
      @current_session.add_player(player)
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

end