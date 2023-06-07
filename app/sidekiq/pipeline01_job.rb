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

    # exec bash script "hola.sh" to process the video
    system("sleep 20")

    # copy video to the same url path the filename is video name .zip
    # get the video name
    video_name = video.name
    # get the video path
    video_path = video.zip.file.path
    video_path_less_filename = video_path.split("/").slice(0..-2).join("/")
    # copy video to the same url path the filename is video name .zip
    puts("**************")
    puts("cp #{video_path} #{video_path_less_filename}/#{video_name}.zip")
    puts("**************")
    system("cp \"#{video_path}\" \"#{video_path_less_filename}/#{video_name}.zip\"")

    # update the status of the video
    video.status = "Processed"
    video.save



  end
end
