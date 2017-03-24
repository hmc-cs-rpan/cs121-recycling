if Rails.env == 'production'
  load Rails.root.join('db', 'seeds', 'production.rb')
else
  load Rails.root.join('db', 'seeds', 'development.rb')
end
