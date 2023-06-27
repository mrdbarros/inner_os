# Use an official Ubuntu runtime as a parent image
FROM ubuntu:latest

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo wget libx11-xcb1 \
    libasound2 libxtst6 libxss1 libnss3 xserver-xorg xinit libgtk-3-0 \
    libgbm1 gnupg python3.10 python3-pip docker docker-compose

# Create a new user with sudo privileges
RUN useradd -m marcel && echo "marcel:marcel" | chpasswd && adduser marcel sudo

# Switch to new user
USER marcel

# Set the working directory in the container to /home/marcel
WORKDIR /home/marcel

# Download VS Code
RUN wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb

# Switch to root to install VS Code
USER root

# Install VS Code
RUN dpkg -i code.deb || apt-get install -fy 

# Switch back to marcel
USER marcel

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

# Keep container running indefinitely
CMD ["tail", "-f", "/dev/null"]