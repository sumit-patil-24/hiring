#!/bin/bash

set -e

PROJECT_DIR="$HOME/hiring/may-2026/devops/quickstart"

echo "==============================="
echo "Updating system packages"
echo "==============================="

sudo apt update
sudo apt install -y \
    git \
    curl \
    unzip \
    nodejs \
    npm \
    python3-pip \
    python3-venv


echo "==============================="
echo "Installing iii"
echo "==============================="

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc


echo "==============================="
echo "Verifying iii installation"
echo "==============================="

iii --version


echo "==============================="
echo "Cloning repository"
echo "==============================="

cd $HOME

if [ ! -d "hiring" ]; then
    git clone https://github.com/sumit-patil-24/hiring.git
fi


echo "==============================="
echo "Installing caller-worker dependencies"
echo "==============================="

cd $PROJECT_DIR/workers/caller-worker
npm install


echo "==============================="
echo "API VM setup complete"
echo "==============================="