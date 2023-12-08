class Api::V0::MarketsController < ApplicationController

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    search_results = Market.all

    return unprocessable_entity(invalid_search_msg) if invalid_search?

    search_results = state_filter(search_results, search_params[:state])
    search_results = city_filter(search_results, search_params[:city])
    search_results = name_filter(search_results, search_params[:name])

    render json: MarketSerializer.new(search_results)
  end

  private

  def search_params
    params.permit(:state, :city, :name)
  end

  def state_filter(query, state_search)
    return query if state_search.blank?

    query.where("lower(state) like ?", "%#{search_params[:state].downcase}%")
  end

  def city_filter(query, city_search)
    return query if city_search.blank?

    query.where("lower(city) like ?", "%#{search_params[:city].downcase}%")
  end

  def name_filter(query, name_search)
    return query if name_search.blank?

    query.where("lower(name) like ?", "%#{search_params[:name].downcase}%")
  end

  def invalid_search_msg
    "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
  end

  def invalid_search?
    invalid_params = [["city"],["city","name"]]
    query_params = params.keys
    query_params.delete("controller")
    query_params.delete("action")
    invalid_params.include?(query_params)
  end

end