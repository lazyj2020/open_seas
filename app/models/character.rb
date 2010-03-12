# Class for model of Character object.  Belongs to user and has a ship.  Stores
# data for the character's skills.
class Character < ActiveRecord::Base
  belongs_to :user
  has_one :ship
  has_many :items, :through => :ships
  validates_numericality_of :unspent_points, :greater_than => -1, :on => :update
  validates_numericality_of :penny, :if => :penny_check?,:less_than=>1,:on=>:update
  validates_numericality_of :goldrush, :if => :goldrush_check?,:less_than=>1,:on=>:update
  validates_numericality_of :cannonmastery, :if => :cannonmastery_check?,:less_than=>1,:on=>:update
  validates_numericality_of :trueshot, :if => :trueshot_check?,:less_than=>1,:on=>:update
  validates_numericality_of :olsturdy, :if => :olsturdy_check?,:less_than=>1,:on=>:update
  validates_numericality_of :smoothsailing, :if => :smoothsailing_check?,:less_than=>1,:on=>:update
  validates_numericality_of :penny, :less_than=>6,:on=>:update
  validates_numericality_of :lucky, :less_than=>6,:on=>:update
  validates_numericality_of :goldrush, :less_than=>2,:on=>:update
  validates_numericality_of :cannonmastery, :less_than=>6,:on=>:update
  validates_numericality_of :cargoreduction, :less_than=>6,:on=>:update
  validates_numericality_of :smoothsailing, :less_than=>2,:on=>:update
  validates_numericality_of :trueshot, :less_than=>2,:on=>:update
  validates_numericality_of :shootingblind, :less_than=>6,:on=>:update
  validates_numericality_of :olsturdy, :less_than=>6,:on=>:update
 # validates_numericality_of :exp_progress, :less_than =>1, :on => :update
  def unspent_points_before_type_cast
    
  end

  # Returns the number of unspent skill points.
  def unspent_points
    total_points - (lucky+penny+goldrush+shootingblind+cannonmastery+trueshot+cargoreduction+olsturdy+smoothsailing)
  end

  # Determines if requirements have been met to allow placing skill points in Penny Pincher
  def penny_check?
    if lucky<3
      return true
    end
  end
  
  # Determines if requirements have been met to allow placing skill points in Gold Rush
  def goldrush_check?
    if penny<3
      return true
    end
  end
  
  # Determines if requirements have been met to allow placing skill points in Cannon Mastery
  def cannonmastery_check?
    if shootingblind<3
      return true
    end
  end
  
  # Determines if requirements have been met to allow placing skill points in True Shot
  def trueshot_check?
    if cannonmastery<3
      return true
    end
  end
  
  # Determines if requirements have been met to allow placing skill points in Ol' Sturdy
  def olsturdy_check?
    if cargoreduction<3
      return true
    end
  end
  
  # Determines if requirements have been met to allow placing skill points in Smooth Sailing
  def smoothsailing_check?
    if olsturdy<3
      return true
    end
  end
  
  # Adds given amount of experience points to the character.
  def exp_gain(exps)
    self.update_attribute(:exp,"#{self.exp + exps}")
    if self.exp >= self.exp_next
      self.update_attribute(:exp_next,"#{self.exp_next + (10 * 2**(self.lvl))}")
      self.update_attribute(:lvl,"#{self.lvl + 1}")
      self.update_attribute(:total_points,"#{self.total_points + 1}")
    end
  end
  
end
