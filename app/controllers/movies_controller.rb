class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by defaultesaas-hw/app/helpers/movies_helper.rb

  end

  def index
    # If sorting or ratings parameters are provided, update the session.
    if params[:sort_by] || params[:ratings]
      session[:sort_by] = params[:sort_by] if params[:sort_by].present?
      session[:ratings] = params[:ratings] if params[:ratings].present?
    else
      # If sorting or ratings parameters aren't provided, restore from the session.
      params[:sort_by] = session[:sort_by] if session[:sort_by].present?
      params[:ratings] = session[:ratings] if session[:ratings].present?
    end
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @ratings_to_show = params[:ratings].present? ? params[:ratings].keys : []
    @movies = params[:sort_by].present? ? Movie.with_ratings(@ratings_to_show, params[:sort_by]): Movie.with_ratings(@ratings_to_show)
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
