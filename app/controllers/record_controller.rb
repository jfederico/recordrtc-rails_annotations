class RecordController < ApplicationController
  before_action :set_account
  before_action :set_recording, except: [:index, :new, :refresh_recordings]

  # GET /record
  def index
    @full_name = session[:full_name]

    @recordings = @account.recordings
  end

  # GET /record/:id
  def show
  end

  # GET /record/new
  def new
    @recording = @account.recordings.new
  end

  # GET /record/:id/edit
  def edit
  end

  def refresh_recordings
    @recordings = @account.recordings

    respond_to do |format|
      format.js
    end
  end

  private
  def set_account
    @account = Account.find_or_create_by!(user_id: session[:user_id])
  end

  def set_recording
    @recording = @account.recordings.find(params[:id])
  end
end
