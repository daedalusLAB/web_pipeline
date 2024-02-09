# Web Pipeline

![Home](https://github.com/daedalusLAB/web_pipeline/assets/1314992/73484312-07e4-4d27-a036-281470c42f88)

## Overview
Web Pipeline is a Rails web application designed to automate video processing workflows. It allows users to upload `.zip` files containing videos for processing through a configurable pipeline, which includes decompression, tool application, and recompression for download. The system also supports job queuing and provides updates via email notifications.

![Dashboard](https://github.com/daedalusLAB/web_pipeline/assets/1314992/f9052f21-b765-47cb-a8fa-52f968c5d03f)


## Features
- **File Uploads**: Users can upload `.zip` files containing videos for processing.
- **Automated Processing Pipeline**: Decompression, video processing with various tools, and recompression.
- **Job Queue**: Processes files in a queue with email status updates.
- **Support for Multiple Tools**: Integration with [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose) and [Whisper](https://github.com/openai/whisper) for video analysis. Tools must be installed on the server.
- **Performance**: Tested with 10-15 second Newscape videos, with processing time around 2 minutes per video in local server.

## Technologies and Libraries
- **Ruby on Rails**: MVC web application framework.
- **PostgreSQL**: Database management.
- **Devise**: Authentication system.
- **Sidekiq with Redis**: Background job processing.
- **CarrierWave**: File uploads.
- **Bootstrap**: Frontend presentation.

## Installation
*ToDo*


## Contributing
Contact Raúl Sánchez <raul@um.es>
