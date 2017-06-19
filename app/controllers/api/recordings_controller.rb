class API::RecordingsController < API::ApplicationController
  before_action :set_recording, only: [:show, :update, :destroy]
  # Not sure if next line is even necessary anymore
  #skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  # GET /api/uploads
  def index
    @recordings = Recording.all.paginate(page: params[:page], per_page: 10)

    render json: @recordings, status: :ok
  end

  # POST /api/uploads
  def create
    @recording = Recording.create!(recording_params)

    render json: @recording, status: :created
  end

  # GET /api/uploads/:id
  def show
    render json: @recording, status: :ok
  end

  # PUT /api/uploads/:id
  def update
    @recording.update(recording_params)

    head :no_content
  end

  # DELETE /api/uploads/:id
  def destroy
    @recording.destroy

    head :no_content
  end

  private
  def recording_params
    params.require(:recording).permit(:title, :description, :video)
  end

  def set_recording
    @recording = Recording.find(params[:id])
  end
end
