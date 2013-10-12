class CatRentalRequestsController < ApplicationController
  before_filter :cat_belongs_to_current_user!, :only => [:approve, :deny]

  def new
    @request = CatRentalRequest.new

    render :new
  end

  def create
    params[:request][:cat_id] = params[:cat]
    @request = CatRentalRequest.new(params[:request])
    if @request.save
      redirect_to cat_url(@request.cat)
    else
      render :new
    end
  end

  def edit
    @request = CatRentalRequest.find(params[:id])
    render :edit
  end

  def update
    @request = CatRentalRequest.find(params[:id])
    raise "you can't edit an unexisting request!" unless @request.persisted?
    if @request.update_attributes(params[:request])
      redirect_to cat_url(@request.cat)
    else
      render :edit
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    redirect_to cat_url(@request.cat)
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    redirect_to cat_url(@request.cat)
  end

  def cat_belongs_to_current_user!
    @request = CatRentalRequest.find(params[:id])
    @cat = @request.cat
    unless @cat.user_id == current_user.id
      flash[:errors] = "You can only approve/deny your own cats"
      redirect_to cat_url(@cat)
    end
  end
end
