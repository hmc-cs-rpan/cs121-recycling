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
In Rails 4, if your app is called hi, and you set session['a'] = 'b', your
cookie will look something like this: 
_hi_session=BAh7B0kiD3%3D%3D--dc40a55cd52fe32bb3b84ae0608956dfb5824689, 
where _hi_session=<encrypted a=b>--<digital signature>.
Cookies are set by server and kept client side, with browser resending set 
cookies to the server every time we request a page. To prevent evil people 
from tampering cookies, a digital signature is used. To prevent evil people 
from understanding a=b string, it's encrypted. In both cases 
secret_key_base value is used (to encrypt/decrypt a=b and to validate 
digital signature).


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

## Tasks for Future Contributors
1. The `Home` button currently takes you to your home city if you have location 
services enabled. Otherwise it will take you to the `Cities` page. Perhaps 
change it so that they will lead to differente pages.
2. Search is currently implemented with `fuzzily`, and because of similarity of
item names, do not return exact item matches. Improve it to return exact matches
where applicable.
3. Implement synonyms for items (e.g. "water bottle" -> "plastic #x")
4. Currently the `Edit` button for cities is accessible to the public. Implement
admin/city official authentication and workflow and hide normal interface
from users.

## History
This application was developed by Jeb Bearer, Ricky Pan, Shailee Samar,
and Kofi Sekyi-Appiah as a project for CS121 at Harvey Mudd Colleve.

## Credits
This project would not have been possible without assistance from our
client Louis Spanias and our professor Yekaterina Kharitonova.
