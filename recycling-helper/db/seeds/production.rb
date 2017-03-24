require 'csv'
require Rails.root.join('db', 'seeds', 'helpers')

# Load all cities in the country!
CSV.foreach Rails.root.join('sample-data', 'all-cities.csv'), headers: true do |row|
  eval_city_csv row
end
