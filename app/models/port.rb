# Class to store Port information.  Carries a list of ships, merchants, and ports
# relating to the current port.
class Port < ActiveRecord::Base
  has_many :ships
  has_many :characters, :through => :ships
  has_many :merchants
  
  has_many :routes_as_start, :foreign_key => 'start_id', 
                             :class_name => 'Route',
                             :dependent => :destroy 
  has_many :routes_as_end,   :foreign_key => 'end_id',   
                             :class_name => 'Route',
                             :dependent => :destroy
  
  has_many :ends, :through => :routes_as_start
  has_many :starts, :through => :routes_as_end
  
end
