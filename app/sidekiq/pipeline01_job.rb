class Pipeline01Job
  include Sidekiq::Job

  def perform(*args)
    # get HPC credentials
    hpc_user = ENV['HPC_USER']
    hpc_host = ENV['HPC_HOST']
    hpc_key = ENV['HPC_KEY']
    hpc_command = ENV['HPC_COMMAND']

    # get the video id and tool dependencies
    video_id = args[0]
    tool_dependencies = args[1] || []  # Default to empty array if not provided
    
    # get the video
    video = Video.find(video_id)
    
    # Convert tool dependencies array to #-separated string
    tools_string = tool_dependencies.join('#')
  
    # get the output of the script and print it to the console. If there is an error, it will be printed to the console
    resultOK = system("bin/pipeline01.sh #{video.zip.file.path} \"#{video.name}\" \"#{video.id}\" \"#{hpc_user}\" \"#{hpc_host}\" \"#{hpc_key}\" \"#{hpc_command}\" \"#{tools_string}\"")
    puts "**********************************************************************"
    puts "resultOK: #{resultOK}"
    if !resultOK
      video.status = "Error"
      video.save
      PipelineMailer.with(user: video.user, status: video.status).status_email.deliver_now
    end
  end
end
