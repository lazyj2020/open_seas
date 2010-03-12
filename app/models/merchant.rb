# Class for Merchants in the game. Carries a list of items that the merchant sells
# along with the port where the merchant is currently located.
class Merchant < ActiveRecord::Base
  belongs_to :port
  has_many :merchant_items
end
