FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

RUN apt-get update
RUN apt-get install -y \
      ffmpeg \
      software-properties-common \
      pkg-config \
      build-essential \
      python3-dev \
      libavcodec-dev \
      libavdevice-dev \
      libavformat-dev \
      libavutil-dev \
      libswresample-dev \
      libswscale-dev 

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ADD . /app
WORKDIR /app
RUN uv sync --frozen
RUN chmod +x ./startup.sh
ENTRYPOINT uv run bash ./startup.sh