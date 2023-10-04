class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list, sort_by = nil)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    query = if ratings_list.empty?
      all
    else
      where(rating: ratings_list)
    end
    
    query = query.order(sort_by => :asc) unless sort_by.nil?

    query
end
end
