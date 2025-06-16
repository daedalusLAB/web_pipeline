# MULTIDATA Pipeline

## Overview
MULTIDATA is an online platform for the study of multimodal communication, funded by an ERASMUS PLUS KA220-HED grant to the University of Murcia, with Radboud University Nijmegen and FAU Erlangen-Nürnberg as partners. We offer an AI-based pipeline to analyze speech and gesture data from videos, as well as other resources for developing audiovisual collections and exploiting them for education, research, and professional applications.

Our platform provides comprehensive tools for analyzing multimodal communication through:
- Automatic speech analysis
- Video transcription with time-alignment
- Human pose estimation and gesture analysis
- Integration with ELAN for detailed annotation
- Advanced data processing and organization

![Home](https://www.multi-data.eu/wp-content/uploads/2025/05/readme5.png)

![Pipeline](https://www.multi-data.eu/wp-content/uploads/2025/05/readme2.jpg)

![Tools](https://www.multi-data.eu/wp-content/uploads/2025/05/readme4.png)

![Webpage](https://www.multi-data.eu/wp-content/uploads/2025/05/readme6.png)

## Features

### Core Functionality
- **File Uploads**: Support for `.zip` files containing videos for processing
- **Automated Processing Pipeline**: Streamlined workflow from decompression through analysis to results
- **Job Queue**: Efficient processing with email status notifications
- **Multi-Tool Integration**: Seamless integration with industry-standard tools

### Analysis Tools
- **Transcription**: Provides time-stamped transcriptions and subtitled videos using [Whisper](https://github.com/openai/whisper).
- **Speech Analysis**: Generates frame-by-frame data for pitch, intensity, harmonicity, and formants using [daedalusLAB/speech_analysis](https://github.com/daedalusLAB/speech_analysis).
- **ELAN Integration**: Creates ELAN files with aligned video transcriptions using [daedalusLAB/create_elan_from_video](https://github.com/daedalusLAB/create_elan_from_video).
- **People Detection**: Identifies people in videos using [People detection tool](https://github.com/daedalusLAB/mario_plumber/tree/main/is_there_a_person_in_the_video) for head and shoulders detection.
- **Openpose Key Bodypoint Detection**: Analyzes human body, hand, and facial keypoints using [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose).
- **DFMaker**: Processes and organizes keypoints data from OpenPose using [daedalusLAB/dfMaker](https://github.com/daedalusLAB/dfMaker).
- **MediaPipe Key Bodypoint Detection**: Analyzes human body, hand, and facial keypoints using [MediaPipe](https://github.com/google/mediapipe).
- **Kinetic HeatMap**: Generates heatmaps from hands keypoints data using [MPI Kinetic HeatMap](https://github.com/Mundgelenk/MPI_MDP).

## Technologies and Libraries

### Backend
- **Ruby on Rails**: Web application framework
- **PostgreSQL**: Database management
- **Redis**: Cache and job queue management
- **Sidekiq**: Background job processing
- **Docker**: Containerization and deployment

### Frontend
- **Bootstrap**: Responsive UI framework
- **JavaScript/Node.js**: Frontend interactivity
- **Yarn**: Package management

## Installation

### Prerequisites
- Ruby (version specified in `.ruby-version`)
- Node.js and Yarn
- PostgreSQL
- Redis
- Docker and Docker Compose (optional)

### Local Setup
1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd web_pipeline
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Configure environment variables:
   - Copy `.env.example` to `.env`
   - Update with your configuration

4. Setup database:
   ```bash
   rails db:create db:migrate
   ```

5. Start the services:
   ```bash
   ./start_app.sh
   ```

### Docker Setup
1. Build the containers:
   ```bash
   docker-compose build
   ```

2. Start the services:
   ```bash
   docker-compose up
   ```

## Usage

1. Register/Login to the platform
2. Upload video files (in .zip format)
3. Select desired analysis tools
4. Monitor job progress via email notifications
5. Download and review results

## Data Privacy

- Videos are processed and then immediately deleted
- No video data is backed up or stored permanently
- Only essential user information is retained
- Secure handling of all uploaded content

## Contributing

We welcome contributions from the research community. Please contact the MULTIDATA Team at <hello@multi-data.eu> for collaboration opportunities.

## Project Partners

- University of Murcia (Lead)
- Radboud University Nijmegen
- FAU Erlangen-Nürnberg
- Red Hen Lab™ (Associated Partner)
- Max Planck Institute for Psycholinguistics (Associated Partner)

## License

This project is funded by the European Union through ERASMUS PLUS KA220-HED. See LICENSE file for details.

## Contact

- Email: hello@multi-data.eu
- Website: [https://www.multi-data.eu](https://www.multi-data.eu)