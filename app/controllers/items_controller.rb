class ItemsController < ApplicationController
  
  def index
    @items = Item.includes(:images).order('created_at DESC')
  end

  def show
    @item = Item.find_by(params[:id])
    @area = Area.find_by(params[:id])
    @status = Status.find(@item[:id])
    @burden = Burden.find(@item[:id])
    @days_to_ship = DaysToShip.find(@item[:id])
    
    @category = Category.find_by(params[:category_id])
  end
  def new
    @item = Item.new
    @item.images.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
    else
      render :new
    end  
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :text, :status, :burden, :area, :days_to_ship, :selliing_price, :category_id, :price, images_attributes: [:image])
  end

end
