require 'test_helper'

class ArticleControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_article_path
    assert_response :success
  end

end
