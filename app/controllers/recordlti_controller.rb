class RecordltiController < ApplicationController
  # GET /recordlti/new
  def new
    @upload = Upload.new
  end

  # GET /recordlti/:id/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # GET /recordlti/:id
  def show
    @upload = Upload.find(params[:id])
  end
end
