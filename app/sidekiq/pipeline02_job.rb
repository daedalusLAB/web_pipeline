class Pipeline02Job
  include Sidekiq::Job

  def perform(*args)
    # exec script to process the file
    # update the status of the video
    # send an email to the user

  # get HPC credentials
  hpc_user = ENV['HPC_USER']
  hpc_host = ENV['HPC_HOST']
  hpc_key = ENV['HPC_KEY']
  
    # get the video id
    video_id = args[0]

    # get the video
    video = Video.find(video_id)
    # update the status of the video

    # EXEC SCP FROM HPC TO LOCAL MACHINE
    # resultOK = system("scp -i #{hpc_key} #{hpc_user}@#{hpc_host}:~/pipeline/#{video_id}/#{video_id}_output/* #{video_id}_output/")

    print("scp -o \"StrictHostKeyChecking no\" -i $hpc_key  $hpc_user@$hpc_host:MULTIDATA/$video_id/#{video.name}.zip #{dirname(video.zip.file.path)}")
    #resultOK = system("scp -o \"StrictHostKeyChecking no\" -i $hpc_key  $hpc_user@$hpc_host:MULTIDATA/$video_id/#{video.name}.zip #{dirname(video.zip.file.path)}")
    resultOK = true
    if resultOK
    # update the status of the video
    video.status = "Processed"
    else
      video.status = "Error"
    end
    video.save
    PipelineMailer.with(user: video.user, status: video.status).status_email.deliver_now

  end
end
