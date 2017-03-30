require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  properties_for Article, required: [:title, :content]
end
