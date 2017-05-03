# Recycling Helper

Recycling Helper is a web-app built for the Hixon Center for Sustainable
Environmental Design in Claremont, CA. The app aims to provide residents with
easy-to-access, digestible information about items that are recyclable for a
particular city. The platform is designed enable expansion across and country
by leveraging crowd-sourcing.

## Installation

1. [Install and set up a Ruby on Rails environment.](http://installrails.com/)

2. Get the source code:
```
git clone https://github.com/hmc-cs-rpan/cs121-recycling.git ~/recycling
cd ~/recycling/recycling-helper
```

3. Install dependencies:
```
bin/bundle install
```

4. Seed the database:

* For production:
```
RAILS_ENV=production SECRET_KEY_BASE=<production secret> bin/rake db:setup
```
This will take some time (10-30 minutes) because it must load data for over
40,000 built-in cities.

* For development:
```
bin/rake db:setup
```
By default, this command will load only 10 cities and generate 10 randomized
sample articles. This is very fast, but if you need more of either model for
testing a particular feature, you can set the environment variables
`NUM_CITIES` and `NUM_ARTICLES`. These can take any nonnegative integer value.
In addition, `NUM_CITIES` can take the value `inf` to load all cities from
[all-cities.csv](https://github.com/hmc-cs-rpan/cs121-recycling/blob/master/recycling-helper/sample-data/all-cities.csv).

5. Start serving requests: `bin/rails s`

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History
This application was developed by Jeb Bearer, Ricky Pan, Shailee Samar,
and Kofi Sekyi-Appiah as a project for CS121 at Harvey Mudd Colleve.

## Credits
This project would not have been possible without assistance from our
client Louis Spanias and our professor Yekaterina Kharitonova.
