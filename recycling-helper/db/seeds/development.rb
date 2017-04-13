require 'csv'
require 'rubygems'
require 'word_salad'
require Rails.root.join('db', 'seeds', 'helpers')

metal = Category.find_by name: 'Metal'
paper = Category.find_by name: 'Paper'
glass = Category.find_by name: 'Glass'
plastic = Category.find_by name: 'Plastic'
food = Category.find_by name: 'Food'

claremont = City.create!  name: 'Claremont',
                          state: 'California',
                          latitude: 34.12,
                          longitude: -117.71,
                          location_id: 'NA-US-CA-CLAREMONT',
                          website_url: 'http://www.ci.claremont.ca.us/'

claremont.zip_codes.create! name: '91711'

claremont_recycle_bin = claremont.bins.create! name: 'recycling', color: '#0000c8'
claremont_compost_bin = claremont.bins.create! name: 'compost', color: '#A52A2A'
claremont_trash_bin = claremont.bins.create! name: 'trash', color: '#000000'

# Items for Claremont (based on the information at http://www.ci.claremont.ca.us/home/showdocument?id=610)
claremont_recycle_bin.add_items!([
  # Aluminum items
  { name: 'Aluminum soda cans', category: metal, image: "Metals/soda_can.jpg" },
  { name: 'Aluminum beer cans', category: metal, image: "Metals/beer_can.jpg" },
  { name: 'Fruit cans', category: metal, image: "Metals/fruit_can.jpg" },
  { name: 'Vegetable cans', category: metal, image: "Metals/veggie_can.jpg" },
  { name: 'Pet food cans', category: metal, image: "Metals/petfood_can.jpg" },
  { name: 'Juice cans', category: metal, image: "Metals/juice_can.png" },
  { name: 'Soup cans', category: metal, image: "Metals/soup_can.jpg" },
  { name: 'Sauce cans', category: metal, image: "Metals/sauce_can.jpg" },
  { name: 'Assorted food cans', category: metal, image: "Metals/assorted_can.jpg", },
  { name: 'Metal Hangers', category: metal, image: "Metals/metal_hanger.jpg"},

  # Paper items
  { name: 'Junk mail', category: paper, image: "Paper/junkmail.jpg" },
  { name: 'Telephone books', category: paper, image: "Paper/telephonebook.jpg" },
  { name: 'Catalogs', category: paper, image: "Paper/catalog.jpg"},
  { name: 'Computer paper', category: paper, image: "Paper/computerpaper.jpg"},
  { name: 'Envelopes', category: paper, image: "Paper/envelope.jpg"},
  { name: 'Wrapping paper', category: paper, image: "Paper/wrap.jpg" },
  { name: 'Brochures', category: paper, image: "Paper/brochure.jpg" },
  { name: 'Crayon drawings', category: paper, image: "Paper/crayondrawing.jpg" },
  { name: 'Office paper', category: paper, image: "Paper/officepaper.jpg" },
  { name: 'Copy paper', category: paper , image: "Paper/copypaper.jpg" },
  { name: 'Cereal boxes', category: paper, image: "Paper/cereal_box.png" },
  { name: 'Tissue boxes', category: paper, image: "Paper/tissue_box.jpg" },
  { name: 'Food boxes', category: paper, image: "Paper/food_box.jpg" },
  { name: 'Milk cartons', category: paper , image: "Paper/milk_carton.jpg" },
  { name: 'Juice boxes', category: paper, image: "Paper/juice_box.png"  },
  { name: 'Soda/beer cartons', category: paper, image: "Paper/soda_carton.jpg" },
  { name: 'Egg cartons', category: paper, image: "Paper/egg_carton.jpg" },
  { name: 'Cardboard boxes', category: paper, image: "Paper/cardboard_box.jpg" },
  { name: 'Paper Bag', category: paper, image: "Paper/paper_bag.jpg" },
  { name: 'Gift boxes', category: paper, image: "Paper/gift_box.jpg" },
  { name: 'Styrofoam packaging (large pieces)', category: paper, image: "Paper/styro_packaging.jpg" },

  # Glass items
  { name: 'Juice bottles', category: glass, image: "Glass/juice_bottle.jpg" },
  { name: 'Beer bottles', category: glass, image: "Glass/beer_bottle.jpg" },
  { name: 'Wine bottles', category: glass, image: "Glass/wine_bottle.png"  },
  { name: 'Liquor bottles', category: glass, image: "Glass/liquor_bottle.jpg"  },
  { name: 'Baby food jars', category: glass, image: "Glass/babyfood_jar.jpg" },
  { name: 'Condiment jars', category: glass, image: "Glass/condiment_jar.jpg"  },
  { name: 'Jam jars', category: glass, image: "Glass/jam_jar.jpg"  },
  { name: 'Jelly jars', category: glass, image: "Glass/jelly_jar.jpg" },
  { name: 'Food Containers', category: glass, image: "Glass/food_container.jpg" },
  { name: 'Assorted food jars', category: glass, image: "Glass/assortedfood_jar.jpg" },
  { name: 'Salad dressing bottles', category: glass, image: "Glass/dressingsalad_bottle.jpg" },

  #Plastic items
  { name: 'Plastic #1', category: plastic, image: "Plastic/water_bottle.jpg" },
  { name: 'Plastic #2', category: plastic, image: "Plastic/milk_jug.jpg" },
  { name: 'Plastic #3', category: plastic, image: "Plastic/shampoo_bottle.jpg" },
  { name: 'Plastic #4', category: plastic, image: "Plastic/condiment_bottle.jpg" },
  { name: 'Plastic #5', category: plastic, image: "Plastic/motor_oil_bottle.jpg" },
  { name: 'Plastic #6', category: plastic, image: "Plastic/cups_plates.jpg" },

  # { name: 'Plastic water bottles', category: plastic },
  # { name: 'Plastic soda bottles', category: plastic },
  # { name: 'Plastic milk jugs', category: plastic },
  # { name: 'Plastic laundry jugs', category: plastic },
  # { name: 'Shampoo bottles', category: plastic },
  # { name: 'Lotion bottles', category: plastic },
  # { name: 'Food containers', category: plastic },
  # { name: 'Condiment bottles', category: plastic },
  # { name: 'Motor oil containers', category: plastic },
  # { name: 'Vegetable oil bottles', category: plastic },
])

# Random items for food
claremont_compost_bin.add_items!([
  # Food items
  { name: 'Organic fruit', category: food, image: "Food/organicfruit.jpg" },
  { name: 'Food scraps', category: food, image: "Food/food_scrap.jpg" },
  { name: 'Compostable paper plates', category: paper, image: "Food/compostablepaper_plate.jpg" },
  { name: 'Biodegradable glass', category: glass, image: "Food/bio_glass.jpg" },
])

# Plastic #7
claremont_trash_bin.add_items!([
  { name: 'Plastic #7', category: plastic, image: "Plastic/safety_goggle.jpg" },
])


# It's useful to have a kind of sandbox city for testing
schmorbodia = City.create!(
  name: 'Schmorbodia',
  state: 'California',  # Not actually, just has to be a valid state
  latitude: 82.86,      # It's actually in Antarctica, apparently
  longitude: 135.00,
  location_id: 'AN-AN-AN-SCHMORBODIA'
)

schmorbodia.zip_codes.create! name: '00000'
schmorbodia.zip_codes.create! name: '55555'

schmorbodia_bin_blue = schmorbodia.bins.create! name: 'blue', color: '#0000c8'
schmorbodia_bin_green = schmorbodia.bins.create! name: 'green', color: '#008000'

schmorbodia_bin_blue.add_items!([
  # Aluminum items
  { name: 'Aluminum soda cans', category: metal },
  { name: 'Aluminum beer cans', category: metal },
  { name: 'Fruit cans', category: metal },
  { name: 'Vegetable cans', category: metal },

  # Paper items
  { name: 'Junk mail', category: paper },
  { name: 'Telephone books', category: paper },
  { name: 'Cereal boxes', category: paper },
  { name: 'Tissue boxes', category: paper },
])

schmorbodia_bin_green.add_items! ([
  # Glass items
  { name: 'Juice bottles', category: glass },
  { name: 'Beer bottles', category: glass },

  # Plastic items
  { name: 'Plastic water bottles', category: plastic },
  { name: 'Plastic soda bottles', category: plastic }
])

# Add some real, empty cities, but not all of them (it takes way too long)
if ENV["NUM_CITIES"].nil?
  num_cities = 10
elsif ENV["NUM_CITIES"].downcase == "inf"
  num_cities = Float::INFINITY
else
  num_cities = ENV["NUM_CITIES"].to_i
end

CSV.foreach Rails.root.join('sample-data', 'all-cities.csv'), headers: true do |row|
  eval_city_csv row
  break if City.count >= num_cities
end

# Create some test users
claremont.officials.create!(
  first_name: 'Harvey',
  middle_name: 'Daniel',
  last_name: 'Mudd',
  email: 'team.daniel.cs121@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

Admin.create!(
  first_name: 'Louis',
  last_name: 'Spanias',
  email: 'team.daniel.cs121@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)

# Terms for the glossary. Selected terms and definitions take from
# http://www.rethinkrecycling.com/businesses/glossary
Term.create!([
  { name: 'biodegradable', definition:
    'Capable of being decomposed by organic processes into elements found in nature when under ' +
    'conditions that allow decomposition. The term may be used in marketing products, sometimes ' +
    'without relevance to whether available disposal methods will allow decomposition.'
  },
  { name: 'composting', definition:
    'The microbial process that breaks down organic waste into a humus-like soil amendment.'
  },
  { name: 'contamination', definition:
    'Inadequate sorting of recyclable materials that interferes with the clean processing of ' +
    'recyclables. For example, a single ceramic coffee mug can cause a ten-ton load of glass ' +
    'bottles to be rejected by the end market; or contamination of office paper can occur if ' +
    'food, carbon paper, metal cans - essentially, any non-paper item - is added to the load.'
  }
])

# Lots of randomly generated articles
if ENV["NUM_ARTICLES"].nil?
  num_articles = 1
else
  num_articles = ENV["NUM_ARTICLES"].to_i
end
(1 .. num_articles).each do |i|
  Article.create! title: "Sample Article #{i}", content: 2.paragraphs.join("<br>")
end

# A sample article. Created after the above, so it displays first in the index
md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
Article.create!(
  title: 'About',
  content: md.render(File.read(Rails.root.join('..', 'README.md')))
)
