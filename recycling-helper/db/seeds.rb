# Categories (based heavily on Claremont, so we will want to relook when we add more cities to avoid
# overfitting our categories)
metal = Category.create!(
  name: 'Metal',
  image_url: 'http://www.knappsnacks.com/wp-content/uploads/2014/08/aluminumcan1.jpg')
paper = Category.create!(
  name: 'Paper',
  image_url: 'https://static.vecteezy.com/system/resources/previews/000/094/161/original/free-notebook-paper-vector.jpg')
cardboard = Category.create!(
  name: 'Cardboard',
  image_url: 'https://recycling.ncsu.edu/wp-content/uploads/2014/10/cardboard.png')
glass = Category.create!(
  name: 'Glass',
  image_url: 'http://www.ikea.com/PIAimages/0183694_PE334729_S5.JPG')
plastic = Category.create!(
  name: 'Plastic',
  image_url: 'http://www.alternet.org/sites/default/files/styles/story_image/public/story_images/plastic.png?itok=8_NKVjx4')
food = Category.create!(
  name: 'Food',
  image_url: 'http://www.ikea.com/PIAimages/0183694_PE334729_S5.JPG')
claremont = City.create!(
  name: 'Claremont',
  state: 'California',
  zip: '91711',
  website_url: 'http://www.ci.claremont.ca.us/'
)

claremont_recycle_bin = claremont.add_bin! 'recycling'

claremont_compost_bin = claremont.add_bin! 'compost'

claremont_trash_bin = claremont.add_bin! 'trash'

# Items for Claremont (based on the information at http://www.ci.claremont.ca.us/home/showdocument?id=610)
claremont_recycle_bin.add_items!([
  # Aluminum items
  { name: 'Aluminum soda cans', category: metal },
  { name: 'Aluminum beer cans', category: metal },
  { name: 'Fruit cans', category: metal },
  { name: 'Vegetable cans', category: metal },
  { name: 'Pet food cans', category: metal },
  { name: 'Juice cans', category: metal },
  { name: 'Soup cans', category: metal },
  { name: 'Sauce cans', category: metal },
  { name: 'Assorted food cans', category: metal },
  { name: 'Metal Hangers', category: metal },

  # Paper items
  { name: 'Junk mail', category: paper },
  { name: 'Telephone books', category: paper },
  { name: 'Catalogs', category: paper },
  { name: 'Computer paper', category: paper },
  { name: 'Envelopes', category: paper },
  { name: 'Wrapping paper', category: paper },
  { name: 'Brochures', category: paper },
  { name: 'Crayon drawings', category: paper },
  { name: 'Office paper', category: paper },
  { name: 'Copy paper', category: paper },

  # Cardboard items
  { name: 'Cereal boxes', category: cardboard },
  { name: 'Tissue boxes', category: cardboard },
  { name: 'Food boxes', category: cardboard },
  { name: 'Milk cartons', category: cardboard },
  { name: 'Juice boxes', category: cardboard },
  { name: 'Soda/beer cartons', category: cardboard },
  { name: 'Egg cartons', category: cardboard },
  { name: 'Paper bags', category: cardboard },
  { name: 'Cardboard boxes', category: cardboard },
  { name: 'Gift boxes', category: cardboard },
  { name: 'Styrofoam packaging (large pieces)', category: cardboard },

  # Glass items
  { name: 'Juice bottles', category: glass },
  { name: 'Beer bottles', category: glass },
  { name: 'Wine bottles', category: glass },
  { name: 'Liquor bottles', category: glass },
  { name: 'Baby food jars', category: glass },
  { name: 'Condiment jars', category: glass },
  { name: 'Jam jars', category: glass },
  { name: 'Jelly jars', category: glass },
  { name: 'Assorted food jars', category: glass },
  { name: 'Salad dressing bottles', category: glass },

  # Plastic items
  { name: 'Plastic water bottles', category: plastic },
  { name: 'Plastic soda bottles', category: plastic },
  { name: 'Plastic milk jugs', category: plastic },
  { name: 'Plastic laundry jugs', category: plastic },
  { name: 'Shampoo bottles', category: plastic },
  { name: 'Lotion bottles', category: plastic },
  { name: 'Food containers', category: plastic },
  { name: 'Condiment bottles', category: plastic },
  { name: 'Motor oil containers', category: plastic },
  { name: 'Vegetable oil bottles', category: plastic },
])

# Random items for food
claremont_compost_bin.add_items!([
  # Food items
  { name: 'Organic fruit', category: food },
  { name: 'Food scraps', category: food },
  { name: 'Compostable paper plates', category: paper },
  { name: 'Biodegradable glass', category: glass },
])

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

# A sample article
md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
Article.create!(
  title: 'About',
  content: md.render(File.read(Rails.root.join('..', 'README.md')))
)

# Because these users have special privileges, and because their passwords are being committed to
# the (public) repository, we have to be careful not to seed them into the production database.
if Rails.env == 'development'

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

end
