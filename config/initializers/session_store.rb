# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Open_Seas_session',
  :secret      => '0b41c6ee18c368d1e8ac530cdef6a43e63245ef9adcea563218a89a9ec19c839660ec090e11d18311d9640c72bdf7422723ea8afb9de3179398c4012a7e3e853'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
