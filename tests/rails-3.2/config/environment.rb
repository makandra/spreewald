# encoding: utf-8

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SpreewaldTest::Application.initialize!

RSPEC_EXPECTATION_NOT_MET_ERROR = RSpec::Expectations::ExpectationNotMetError
