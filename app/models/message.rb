# Message object for the Messenger system
class Message < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :message_copies
  has_many :recipients, :through => :message_copies
  
  before_create :prepare_copies
  
  attr_accessor  :to # array of people to send to
  attr_accessible :subject, :body, :to
  
  # Make copies for sending messages to multiple users
  def prepare_copies
    return if to.blank?
    
    to.each do |recipient|
      recipient = User.find(recipient)
      message_copies.build(:recipient_id => recipient.id, :folder_id => recipient.inbox.id, :read => false)
    end
  end
  
end
