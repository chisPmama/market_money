class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    market = Market.find_by(id: params[:id])

    if market
      render json: MarketSerializer.new(Market.find(params[:id]))
    else
      render json: { status: 404, errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }
    end
  end
end