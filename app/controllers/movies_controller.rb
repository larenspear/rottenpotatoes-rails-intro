class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.class_variable_get(:@@all_ratings)
    if !session.has_key?(:ratings)
      @ratings = Movie.class_variable_get(:@@all_ratings)
    else
      @ratings = session[:ratings]
    end

    if params[:sort] == 'sort_by_release' or params[:sort] == 'sort_by_title'
      session[:sort] = params[:sort]
    end

    if params.has_key?(:ratings)
      if @ratings.length > 0
        @ratings = params['ratings'].keys()
        session[:ratings] = @ratings
      else
        @ratings = session[:ratings]
      end
    end

    if !session.has_key?(:ratings)
      session[:ratings] = @ratings
    end

    if session[:sort] == 'sort_by_release'
      @movies = Movie.with_ratings(@ratings).order('release_date')
    elsif session[:sort] == 'sort_by_title'
      @movies = Movie.with_ratings(@ratings).order('title')
    else
      @movies = Movie.with_ratings(@ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
