# Categories (based heavily on Claremont, so we will want to relook when we add more cities to avoid
# overfitting our categories)
Category.create!(
  name: 'Metal',
  image_url: 'http://www.knappsnacks.com/wp-content/uploads/2014/08/aluminumcan1.jpg')
Category.create!(
  name: 'Paper',
  image_url: 'https://static.vecteezy.com/system/resources/previews/000/094/161/original/free-notebook-paper-vector.jpg')
Category.create!(
  name: 'Glass',
  image_url: 'http://www.ikea.com/PIAimages/0183694_PE334729_S5.JPG')
Category.create!(
  name: 'Plastic',
  image_url: 'http://www.alternet.org/sites/default/files/styles/story_image/public/story_images/plastic.png?itok=8_NKVjx4')
Category.create!(
  name: 'Food',
  image_url: 'http://www.ikea.com/PIAimages/0183694_PE334729_S5.JPG')


if Rails.env == 'production'
  load Rails.root.join('db', 'seeds', 'production.rb')
else
  load Rails.root.join('db', 'seeds', 'development.rb')
end
