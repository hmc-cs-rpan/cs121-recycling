require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  require_properties_for Article, :title, :content
end
