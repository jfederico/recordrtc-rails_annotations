class API::UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  # GET /api/uploads
  # GET /api/uploads.json
  def index
    @uploads = Upload.all.paginate(page: params[:page], per_page: 20)

    json_response(@uploads)
  end

  # POST /api/uploads
  # POST /api/uploads.json
  def create
    @upload = Upload.create!(upload_params)

    json_response(@upload, :created)
  end

  # GET /api/uploads/:id
  # GET /api/uploads/:id.json
  def show
    json_response(@upload)
  end

  # PUT /api/uploads/:id
  # PUT /api/uploads/:id.json
  def update
    @upload.update(upload_params)

    head :no_content
  end

  # DELETE /api/uploads/:id
  # DELETE /api/uploads/:id.json
  def destroy
    @upload.destroy

    head :no_content
  end

  private

  def upload_params
    params.require(:upload).permit(:title, :description, :video)
  end

  def set_upload
    @upload = Upload.find(params[:id])
  end
end
