class ReservationsController < ApplicationController
  before_action :authenticate_user! 
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @reservations = Reservation.all
    gon.last = Reservation.last
    gon.reservations = @reservations
    gon.user = current_user.try(:name)
    gon.admin = current_user.try(:admin)
  end

  def show
  	@reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    respond_to do |format|
      format.html #new.html.erb
      format.json { render json: @reservation}
    end 
  end

  def update
  	@reservation = Reservation.find(params[:id])
 
  	if @reservation.update(cleaned_res_params) #if we successfully save, show us the res on a show.html.erb view
    	redirect_to @reservation
  	else
    	render 'edit'
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def create
   @reservation = Reservation.new(cleaned_res_params)
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: "Save process completed!" }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        format.html { 
          flash.now[:notice]="Save proccess coudn't be completed!" 
          render :new 
        }
        format.json { render json: @reservation.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
	  @reservation = Reservation.find(params[:id])
	  @reservation.destroy
	 
	  redirect_to reservations_path #same as render 'index'
  end

  private
  def cleaned_res_params
    params.require(:reservation).permit(:user_id,:name,:phone,:start,:duration,:court,:gtid,:gtuser,:email,:guest1,:guest2,:guest3)
  end

end
