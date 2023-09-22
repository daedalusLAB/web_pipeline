class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy ]

  # check if user is logged in
  before_action :authenticate_user!

  # GET /videos or /videos.json
  def index
    # get all videos ordered by created_at
    @videos = Video.order(created_at: :desc)
    #@videos = current_user.videos
  end

  # # GET /videos/1 or /videos/1.json
  # def show
  # end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # # GET /videos/1/edit
  # def edit
  # end

  # POST /videos or /videos.json
  def create
    @video = Video.new(video_params)
    @video.user = current_user
    @video.status = "Queued"

    respond_to do |format|
      if @video.save

        # send the video to the pipeline
        Pipeline01Job.perform_async(@video.id)
        PipelineMailer.with(user: @video.user, status: @video.status).status_email.deliver_now
        #format.html { redirect_to video_url(@video), notice: "Video was successfully created." }
        format.json { render :show, status: :created, location: @video }
        # redirect to the videos index page
        format.html { redirect_to videos_url, notice: "Zip was successfully created." }

      else
        @video.status = "Failed"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  # def update
  #   respond_to do |format|
  #     if @video.update(video_params)
  #       format.html { redirect_to video_url(@video), notice: "Video was successfully updated." }
  #       format.json { render :show, status: :ok, location: @video }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @video.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /videos/1 or /videos/1.json
  def destroy

    # delete the video zip file
    video_name = @video.name
    # get the video path
    video_path = @video.zip.file.path
    video_path_less_filename = video_path.split("/").slice(0..-2).join("/")
    system("rm \"#{video_path_less_filename}/#{video_name}.zip\"")
    
    @video.destroy

    # delete the video from the pipeline


    respond_to do |format|
      format.html { redirect_to videos_url, notice: "Zip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:name, :zip, :user_id)
    end
end
