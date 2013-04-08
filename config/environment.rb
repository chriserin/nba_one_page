# Load the rails application
require File.expand_path('../application', __FILE__)

#Mongoid.load!("./config/mongoid.yml", Rails.env)
p "params: #{params}" if defined? params
p ENV["MONGOHQ_URL"]
# Initialize the rails application
NbaOnePage::Application.initialize!
