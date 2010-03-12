# Class for storing the User information 
class User < ActiveRecord::Base
  
  has_many :sent_messages, :class_name => "Message", :foreign_key => "author_id"
  has_many :received_messages, :class_name => "MessageCopy", :foreign_key => "recipient_id"
  has_many :folders
  has_one :character
  before_create :build_inbox

  # Returns the Inbox for the User
  def inbox
    folders.find_by_name("Inbox")
  end

  # Creates a new Inbox for the User
  def build_inbox
    folders.build(:name => "Inbox")
  end
  
  #Max & min lengths for all fields
  ACCOUNT_MIN_LENGTH=4
  ACCOUNT_MAX_LENGTH=20
  PASSWORD_MIN_LENGTH=4
  PASSWORD_MAX_LENGTH=40
  EMAIL_MAX_LENGTH=50
  ACCOUNT_RANGE=ACCOUNT_MIN_LENGTH..ACCOUNT_MAX_LENGTH
  PASSWORD_RANGE=PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  ACCOUNT_SIZE = 20 
  PASSWORD_SIZE =  10 
  EMAIL_SIZE = 30 
  
  
  attr_accessor :remember_me 
  validates_uniqueness_of :account, :email
  validates_length_of :account, :within => ACCOUNT_RANGE
  validates_length_of :password, :within => PASSWORD_RANGE
  validates_length_of :email, :maximum => EMAIL_MAX_LENGTH 

  validates_format_of :account, 
                      :with => /^[A-Z0-9_]*$/i, 
                      :message => "must contain only letters, " + 
                                  "numbers, and underscores" 
  validates_format_of :email, 
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i, 
                      :message => "must be a valid email address"

  # Checks validation of the User's input
  def  validate 
    errors.add(:email, "must be valid.") unless email.include?("@") 
    if account.include?(" ") 
      errors.add(:account,"cannot include spaces.") 
    end 
  end
  
 #  Log a user in. 
   def login!(session) 
      session[:user_id] = id 
  end

  #  Log a  user out. 
  def  self.logout!(session) 
    session[:user_id]    = nil 
  end 


  def logout 
    User.logout!(session, cookies) 
    flash[:notice] = "Logged out" 
    redirect_to :action => "index", :controller => "site" 
  end 

  # Clears the password from the text_field
  def clear_password! 
    self.password = nil 
  end

  # Returns and encrypted 
  def give_encrypted(string)
    Digest::MD5.hexdigest(string)
  end
end
