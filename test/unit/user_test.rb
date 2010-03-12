require File.dirname(__FILE__) + '/../test_helper' 

class UserTest < ActiveSupport::TestCase
  fixtures :users 

  def setup 
    @error_messages = I18n.translate('activerecord.errors.messages')

  end 


    
  def test_uniqueness_of_account_and_email 
    user_repeat = User.new(:account => @valid_user.account, :email => @valid_user.email, :password => @valid_user.password) 
    assert !user_repeat.valid? 
    assert_equal "has already been taken", user_repeat.errors.on(:account) 
    assert_equal "has already been taken", user_repeat.errors.on(:email) 
  end 
   
   
  def  test_screen_name_minimum_length 
    user = @valid_user 
    min_length = User::ACCOUNT_MIN_LENGTH 
    user.account = "a"  * (min_length - 1) 
    assert !user.valid?, "#{user.account} should raise a minimum length error" 
    correct_error_message = I18n.translate"activerecord.errors.messages.too_short", :count => min_length
    assert_equal correct_error_message, user.errors.on(:account) 
    user.account = "a" * min_length 
    assert user.valid?, "#{user.account} should be just long enough to pass" 
  end 
  
  def test_email_maximum_length 
    user = @valid_user 
    max_length = User::EMAIL_MAX_LENGTH 

    user.email = "a" * (max_length - user.email.length + 1) + user.email 
    assert !user.valid?, "#{user.email} should raise a maximum length error" 
 
    correct_error_message = I18n.translate"activerecord.errors.messages.too_long", :count => max_length
 
    assert_equal correct_error_message, user.errors.on(:email) 
  end   
end
