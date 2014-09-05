class MeetingsController < ApplicationController
  def show
    @meeting = Meeting.find(params[:id])
  end

  def index
    @meetings = Meeting.all
  end

  def new
    @meeting = Meeting.new
    3.times { @meeting.meeting_materials.new }
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.time = parse_time_with_correct_zone(params[:meeting][:time])
    if @meeting.save
      UserMailer.notify_new_meeting(@meeting).deliver!
      flash[:success] = "Meeting created"
      redirect_to @meeting
    else
      flash.now[:error] = "Unable to create meeting"
      render :new
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.time = parse_time_with_correct_zone(params[:meeting][:time])
    if @meeting.update_attributes(meeting_params)
      flash[:success] = "Meeting updated"
      redirect_to @meeting
    else
      flash.now[:error] = "Unable to save changes"
      render :edit
    end
  end

  def destroy
    Meeting.find(params[:id]).destroy
    flash[:success] = "Meeting deleted"
    redirect_to root_path
  end

  private

    def meeting_params
      params.require(:meeting)
            .permit(:title, :time,
                    meeting_materials_attributes: [:id, :material, 
                                                   :delete_material, :_destroy])
    end
end
