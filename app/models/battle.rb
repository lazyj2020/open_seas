# This Class is designed to execute battles and save their result as records
# for each user.
class Battle < ActiveRecord::Base
  
  # Algorithm to battle two ships.  Battle follows this structure:
  # * Determines if either ship has been scuttled (killed) previously
  # * Checks if a ship is trying to flee and calculates if it occurs
  # * Iterates over each cannon for each ship, and determines if the cannon hits or misses
  # * checks if either ship has been scuttled and continues
  def battle(ship_id1, ship_id2)
    
    @battle = Battle.new()
    
    @battle.ship1_id = ship_id1
    @ship1 = Ship.find(ship_id1)
    @battle.ship2_id = ship_id2
    @ship2 = Ship.find(ship_id2)
 
    hp1 = @ship1.curr_hp
    hp2 = @ship2.curr_hp
    
    scuttled = false
    battleover = false
    battleresult = ""
    if hp1 <= 0
      battleover = true
      scuttled = true
      battleresult = "#{@ship2.name} passes a scuttled ship, #{@ship1.name}"
    elsif hp2 <= 0
      battleover = true
      scuttled = true
      battleresult = "#{@ship1.name} passes a scuttled ship, #{@ship2.name}"
    end
    attacker = nil
    defender = nil
    if @ship1.evasion > @ship2.evasion
      attacker = @ship1
      defender = @ship2
    elsif @ship2.evasion > @ship1.evasion
      attacker = @ship1
      defender = @ship2
    else
      if rand(2) == 1
        attacker = @ship1
        defender = @ship2
      else
        attacker = @ship2
        defender = @ship1
      end
    end
    while (!battleover)
      trues = false
      if attacker.character.trueshot > 0
          trues = true
      end
      if attacker.flee > 0
        flee = false
        if attacker.flee_mod_type == 'all'
          flee = true
        elsif attacker.flee_mod_type == 'HP% <' 
          if attacker == @ship1
            if attacker.flee_mod_num <= (hp1 / @ship1.hitpoints)
              flee = true
            end
          else
            if attacker.flee_mod_num <= (hp2 / @ship2.hitpoints)
              flee = true
            end
          end
        end
        if flee
          if (attacker.evasion * 10) + attacker.character.lucky > rand(30) 
            battleresult = "#{battleresult}#{attacker.name} successfully flees!\n"
            battleover = true
          else
            battleresult = "#{battleresult}#{attacker.name} tries to flee but fails.\n"
          end
        end
      else  
        attacker.ship_items.each do |itm|
          
          if (itm.equiped and itm.item.slot == "weapon")
            
            if (itm.item.accuracy_w + (attacker.character.cannonmastery * 0.5) - (defender.evasion) > rand(10))
              if attacker == @ship1
                hp2 -= itm.item.attack_w + attacker.character.shootingblind
                 battleresult = "#{battleresult}#{attacker.name} Hits #{defender.name} for #{itm.item.attack_w + attacker.character.shootingblind} HP[#{hp2}/#{defender.curr_hp}] \n"
              else
                hp1 -= itm.item.attack_w + attacker.character.shootingblind
                battleresult = "#{battleresult}#{attacker.name} Hits #{defender.name} for #{itm.item.attack_w + attacker.character.shootingblind} HP[#{hp1}/#{defender.curr_hp}] \n"
 
              end
              else
              if trues
               if attacker == @ship1
                hp2 -= itm.item.attack_w + attacker.character.shootingblind
                 battleresult = "#{battleresult}#{attacker.name} Hits #{defender.name} for #{itm.item.attack_w + attacker.character.shootingblind} using trueshot! HP[#{hp2}/#{defender.curr_hp}] \n"
              else
                hp1 -= itm.item.attack_w + attacker.character.shootingblind
                battleresult = "#{battleresult}#{attacker.name} Hits #{defender.name} for #{itm.item.attack_w + attacker.character.shootingblind} using trueshot! HP[#{hp1}/#{defender.curr_hp}] \n"
 
              end
                
                trues = false
              else
                battleresult = "#{battleresult}#{attacker.name} Misses\n"
              end
            end
          end
        end    
      end
      
      if (hp2 <= 0 or hp1 <= 0)
        battleover = true
      else
      battleresult = "#{battleresult}#{defender.name}'s move\n"
      if attacker == @ship1
        attacker = @ship2
        defender = @ship1
      else
        attacker = @ship1
        defender = @ship2
      end
        
      end
    end
    @winner = "No one "
    if (hp2 <= 0) and (!scuttled)
      battleresult = "#{battleresult}#{@ship1.name} WON\n"
      @winner = @ship1.name
      @ship2.update_attribute(:curr_hp,"0")
      @ship1.update_attribute(:curr_hp,"#{hp1}")
      @ship1.character.exp_gain(@ship2.character.lvl)
      @ship1.character.update_attribute(:gold,"#{@ship1.character.gold + 20*(1+@ship1.character.goldrush)}")
      @ship2.character.update_attribute(:gold,"#{@ship2.character.gold + 5*(1+@ship2.character.goldrush)}")
    elsif (hp1 <= 0) and (!scuttled)
      battleresult = "#{battleresult}#{@ship2.name} WON\n"
      @winner = @ship2.name
      @ship1.update_attribute(:curr_hp,"0")
      @ship2.update_attribute(:curr_hp,"#{hp2}")
      @ship2.character.exp_gain(@ship1.character.lvl)
      @ship1.character.update_attribute(:gold,"#{@ship1.character.gold + 5*(1+@ship1.character.goldrush)}")
      @ship2.character.update_attribute(:gold,"#{@ship2.character.gold + 20*(1+@ship2.character.goldrush)}")
    end
    
    @battle.recap = battleresult

    #respond_to do |format|
    @battle.save
    @time_taska = TimeTask.new(
      :name => "show_battle_ship1",
      :task => "show_battle",
      :param1 => @battle.ship1_id,
      :param2 => @battle.id,
      :when => Time.now
    )
    @time_taska.save
    
    @time_taska = TimeTask.new(
      :name => "show_battle_ship2",
      :task => "show_battle",
      :param1 => @battle.ship2_id,
      :param2 => @battle.id,
      :when => Time.now
    )
    @time_taska.save

    @news_post = NewsPost.new(
      :author => "System",
      :subject => "A Battle has occured!",
      :body => "
      Oh No! #{@ship1.name} encountered #{@ship2.name} on the high seas! \n
      A fierce battle occured! #{@winner} won the fight. "
    )
    @news_post.save
    
    return @battle
  end
end
