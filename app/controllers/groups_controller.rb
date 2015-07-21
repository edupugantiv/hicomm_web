class GroupsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update,:destroy]
  before_action :authenticate_user!


  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params.require(:group).permit(:user_id, :name, :latitude, :longitude))
    if @group.save
      redirect_to 'index', notice: "Group created"
    else
      render :new, notice: "Group not created"
    end
  end

  def show
    @group = Group.find(params[:id])
  end 

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      redirect_to 'index', notice: "Left group"
    else
      render :new, notice: "Still in group"
    end
  end

  def set_cart
    @group = Group.find(params[:id])
  end
end