# Class to store connecting ports with information for distance and commonalities
# between routes.
class Route < ActiveRecord::Base
  belongs_to :start, :class_name => "Port"
  belongs_to :end, :class_name => "Port"
  
end
