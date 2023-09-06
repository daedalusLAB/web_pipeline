class Pipeline01Job
  include Sidekiq::Job

  def perform(*args)
    # exec script to process the file
    # update the status of the video
    # send an email to the user

    # get the video id
    video_id = args[0]

    # get the video
    video = Video.find(video_id)
    # update the status of the video
    video.status = "Processing"
    video.save

    # exec pipeline script in the rails app bin folder to process the videos
    puts "**********************************************************************"
    puts "bin/pipeline.sh #{video.zip.file.path}  \"#{video.name}\" "
    system("bin/pipeline.sh #{video.zip.file.path}  \"#{video.name}\" ")
    puts "**********************************************************************"

    # update the status of the video
    video.status = "Processed"
    video.save



  end
end
