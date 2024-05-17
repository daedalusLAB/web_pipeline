class Pipeline02Job
  include Sidekiq::Job

  def perform(*args)
    # get HPC credentials
    hpc_user = ENV['HPC_USER']
    hpc_host = ENV['HPC_HOST']
    hpc_key = ENV['HPC_KEY']
    hpc_command = ENV['HPC_COMMAND']

    # get the video id and video and destination path
    video_id = args[0]
    video = Video.find(video_id)
    destination_path = File.dirname(video.zip.file.path)
  
    # get the output of the script and print it to the console. If there is an error, it will be printed to the console
    resultOK = system("bin/pipeline02.sh #{video.zip.file.path}  \"#{video.name}\" \"#{video.id}\" \"#{hpc_user}\" \"#{hpc_host}\" \"#{hpc_key}\" \"#{hpc_command}\"  \"#{destination_path}\" ")
    puts "**********************************************************************"
    puts "resultOK: #{resultOK}"
    if !resultOK
      video.status = "Error"
      video.save
    else
      video.status = "Processed"
      video.save
    end
    PipelineMailer.with(user: video.user, status: video.status).status_email.deliver_now
  end
end