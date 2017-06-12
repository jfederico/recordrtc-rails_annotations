class RecordRTCController < ApplicationController
  # GET /recordrtc/new
  def new
    @upload = Upload.new
  end

  # GET /recordrtc/:id/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # GET /recordrtc/:id
  def show
    @upload = Upload.find(params[:id])
  end
end
