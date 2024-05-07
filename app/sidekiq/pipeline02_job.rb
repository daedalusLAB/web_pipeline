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
    #print("scp -o \"StrictHostKeyChecking no\" -i $hpc_key  $hpc_user@$hpc_host:MULTIDATA/$video_id/#{video.name}.zip #{File.dirname(video.zip.file.path)}")
    resultOK = system("scp -o \"StrictHostKeyChecking no\" -i #{hpc_key}  #{hpc_user}@#{hpc_host}:\"MULTIDATA/#{video_id}/#{video.name}.zip\" #{File.dirname(video.zip.file.path)}")
    #resultOK = true
    print("RESULT OK OF SCP: #{resultOK}")
    if resultOK
    # update the status of the video
      video.status = "Processed"
    else
      video.status = "Error"
    end
    video.save
    PipelineMailer.with(user: video.user, status: video.status).status_email.deliver_now
    # delete remote folder MULTIDA/$video_id 
    #print ("ssh -o \"StrictHostKeyChecking no\" -i #{hpc_key}  #{hpc_user}@#{hpc_host} \"rm -rf MULTIDATA/#{video_id}\"")
    if video_id.is_a? Integer
      print("Deleting remote folder MULTIDA/#{video_id}")
      system("ssh -o \"StrictHostKeyChecking no\" -i #{hpc_key}  #{hpc_user}@#{hpc_host} \"rm -rf MULTIDATA/#{video_id}\"")
    else
      print("Error: video_id is not an integer")
    end
    
  end
end
