# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_spreewald_test_session',
  :secret      => 'cd29dba6c040376838de77ac6d96c2ca6377989989069d4da7abe097b50ef0679dc60251bdee61cb9e7da1253546fe9af87b74752725f91bdbb258f22f061102'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
