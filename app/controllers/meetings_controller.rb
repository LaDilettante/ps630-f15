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
    n = [0, 3 - @meeting.meeting_materials.count].max
    n.times { @meeting.meeting_materials.new }
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.time = parse_time_with_correct_zone(params[:meeting][:time])
    if @meeting.save
      User.all.each do |user|
        UserMailer.notify_new_meeting(@meeting, user).deliver!
      end 
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
                                                   :_destroy])
    end
end
