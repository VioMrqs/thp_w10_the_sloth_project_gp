class CardsController < ApplicationController

  def new
    @card = Card.new
    @picture = Picture.find(params[:picture_id])
    @quantity = params[:quantity]
  end

  def create
    @picture = Picture.find(params[:card][:picture_id])
    @quantity = params[:card][:quantity]
    @card = Card.new(user: current_user, picture: @picture, quantity: @quantity)
      if @card.save
        flash[:notice] = "Photo ajoutée au panier"
        redirect_to cards_path
      else
        flash.now[:danger] = "Tu ne peux pas l'ajouter au panier !"
    end
  end

  def index
    @cards = Card.where(user: current_user).sort_by(&:picture_id)         
    session[:amount] = total_price
  end

  def edit
    @card = Card.find(params[:id])
  end

  def update
    @card = Card.find(params[:id])
    if @card.update(quantity: params[:quantity])
      redirect_to cards_path
    else
      redirect_to cards_path
    end
  end

  def destroy
    @destroy_card = Card.find(params[:id])
    @destroy_card.destroy
    redirect_to cards_path
  end

  private

  def total_price
    @total_price = 0
    Card.where(user: current_user).each do |card|
    @total_price = @total_price + card.picture.price
    end
    return @total_price
  end

end