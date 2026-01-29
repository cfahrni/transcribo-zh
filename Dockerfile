FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

RUN apt-get update
RUN apt-get install -y \
      ffmpeg curl gnupg ca-certificates \
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

# NVIDIA Repo Keyring (modern)
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb -o /tmp/cuda-keyring.deb
RUN dpkg -i /tmp/cuda-keyring.deb && rm -f /tmp/cuda-keyring.deb

# cuDNN 8 (Pakete)
RUN apt-get update && apt-get install -y \
    libcudnn8 libcudnn8-dev

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ADD . /app
WORKDIR /app
RUN uv sync --frozen
RUN chmod +x ./startup.sh
ENTRYPOINT uv run bash ./startup.sh