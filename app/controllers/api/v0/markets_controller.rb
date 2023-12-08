class Api::V0::MarketsController < ApplicationController

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    search_results = Market.all

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

end