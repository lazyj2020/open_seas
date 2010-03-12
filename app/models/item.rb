# Class for storing general Item information.
class Item < ActiveRecord::Base
  has_many :ship_items
  has_many :merchant_items
end
