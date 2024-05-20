class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy processed processing error ]

  # check if user is logged in
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:processed, :processing, :error]

  # check ip and token before_action for processed action
  before_action :check_ip_and_token, only: [:processed, :processing, :error]

  # GET /videos or /videos.json
  def index
    # get all videos ordered by created_at
    #@videos = Video.order(created_at: :desc)
    if current_user.admin?
      @videos = Video.order(created_at: :desc).page(params[:page]).per(10)
    else
      @videos = current_user.videos.order(created_at: :desc).page(params[:page]).per(10)
    end
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
        format.html { redirect_to videos_url, notice: "Task was successfully created." }

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
      format.html { redirect_to videos_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def processed
    @video.status = "Processed"
    @video.save
    # run job to exec pipeline_02_job.rb to scp zip file from hpc to local
    Pipeline02Job.perform_async(@video.id)
    redirect_to videos_url, notice: "Video was successfully processed. Copying files to local machine."
  end

  def processing
    @video.status = "Processing"
    @video.save
    PipelineMailer.with(user: @video.user, status: @video.status).status_email.deliver_now
    redirect_to videos_url, notice: "Video is processing."
  end

  def error
    @video.status = "Error"
    @video.save
    PipelineMailer.with(user: @video.user, status: @video.status).status_email.deliver_now
    redirect_to videos_url, notice: "Video was processed with error. Copying files to local machine."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:name, :zip, :user_id, :token)
    end

    # check ip and token before_action for processed action
    def check_ip_and_token
      print "check_ip_and_token\n"
      # check if the request is in the list of allowed IPs from .envfile
      print "CURL FROM: #{request.remote_ip} \n"
      print "ALLOWED_IPS: #{ENV['ALLOWED_IPS']} \n"
      if ENV['ALLOWED_IPS'].split(",").include? request.remote_ip
        # check if the token is correct
        # print remote_ip
        print "CURL FROM: #{request.remote_ip} \n"
      end

      if params[:token] == ENV['PROCESSED_TOKEN']
          print "TOKEN: #{params[:token]} \n is correct"
          return
      end
      print "****** TOKEN: #{params[:token]} is incorrect ********\n"
      # if the token is incorrect or the IP is not allowed, redirect to the root path
      redirect_to root_path
    end

end
