class RecordRTCController < ApplicationController
  before_action :set_recording, except: :new

  # GET /recordrtc/:id
  def show
  end

  # GET /recordrtc/new
  def new
    @recording = Recording.new
  end

  # GET /recordrtc/:id/edit
  def edit
  end

  private
  def set_recording
    @recording = Recording.find(params[:id])
  end
end
