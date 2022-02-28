class Movie < ActiveRecord::Base

  @@all_ratings = ['G','PG','PG-13','R']

  def self.with_ratings(ratings)
    Movie.where(rating: ratings)
  end


end
