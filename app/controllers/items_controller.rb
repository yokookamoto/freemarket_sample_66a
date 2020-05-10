class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :move_to_root, except: [:index, :show, :top]
  before_action :correct_user, only: [:edit, :update]


  def index
    @items = Item.all
    sold_out_item_ids = Buyer.all.pluck(:item_id)
    @item = Item.order(id: "DESC").where.not(id: sold_out_item_ids).first(3)
  end

  def show
    @grandchild_category = Category.find(@item[:category_id])
    @child_category = @grandchild_category.parent
    @parent_category = @child_category.parent
  end

  def new
    
    @item = Item.new
    @item.images.new
    
    def get_category_children
      @category_children = Category.find_by(id: "#{params[:parent_id]}", ancestry: nil).children
    end
  
    def get_category_grandchildren
      @category_grandchildren = Category.find("#{params[:child_id]}").children
    end
  end


  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: "出品しました"
    else
      flash.now[:alert] = "出品できません。入力必須項目を確認してください"
      render :new
    end
  end

  def edit
    @category_parent_array = Category.where(ancestry: nil)
  end


  def update
    if @item.update(item_params)
      redirect_to item_path(@item.id), notice: "編集しました"
    else
      flash.now[:alert] = "編集できません。入力必須項目を確認してください"
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :text, :status_id, :burden_id, :area_id, :days_to_ship_id, :selling_price, :category_id, :brand, images_attributes: [:image, :_destroy, :id]).merge(saler_id: current_user.id) 
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_root
    redirect_to root_path unless user_signed_in?
  end

  def correct_user
    if @current_user.id !=  @item.saler_id
     redirect_to root_path
    end
  end

end
