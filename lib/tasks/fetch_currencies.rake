require 'dotenv/tasks'

namespace :fetch_currencies do
  desc "Get currencies every 1 hour"
  task hourly: :environment do
    # loop do
      currencies = Currency.all.pluck(:name).join(', ')
      response = HTTParty.get("http://data.fixer.io/api/latest?access_key=#{ENV['ACCESS_KEY']}&symbols=#{currencies}")
      json = JSON.parse(response.body)
      if !json.nil?
        json["rates"].each do |key, value|
          currency = Currency.find_by(name: key.upcase)
          currency.update(last_value: value.to_d)
        end
        puts 'Updated currencies values'
      else
        puts "Error updating currencies values"
      end
    #   sleep(3600)
    # end
  end
end
