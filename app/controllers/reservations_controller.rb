class ReservationsController < ApplicationController
  before_action :authenticate_user! 
  skip_before_action :authenticate_user!, only: [:index]

  def index
	 @reservations = Reservation.all
  end

  def show
  	@reservation = Reservation.find(params[:id])
  end

  def new
  	@reservation = Reservation.new
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
 
	if @reservation.save
		redirect_to @reservation #could also render 'index' to go back to calendar view
	else
		render 'new'
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
