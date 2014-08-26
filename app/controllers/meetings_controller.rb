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
    3.times { @meeting.meeting_materials.new }
  end

  def create
    @meeting = Meeting.find(meeting_params)
    if @meeting.save
      flash[:success] = "Meeting created"
      redirect_to @meeting
    else
      flash.now[:error] = "Unable to create meeting"
      render :new
    end
  end

  private

    def meeting_params
      params.require(:meeting)
            .permit(:title, meeting_materials_attributes: [:material])
    end
end
