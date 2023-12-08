class Api::V0::MarketsController < ApplicationController

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    search_results = Market.all
                           .where("lower(state) like ?", "%#{search_params[:state].downcase}%")
                           .where("lower(city) like ?", "%#{search_params[:city].downcase}%")
                           .where("lower(name) like ?", "%#{search_params[:name].downcase}%")
    render json: MarketSerializer.new(search_results)
  end

  private

  def search_params
    params.permit(:state, :city, :name)
  end
end