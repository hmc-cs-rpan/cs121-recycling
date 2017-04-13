class Article < ApplicationRecord
  validates :title, :content, presence: true

  fuzzily_searchable :title, :content

  def self.fuzzy_search(query)
    return find_by_fuzzy_title(query) | find_by_fuzzy_content(query)
  end
end
