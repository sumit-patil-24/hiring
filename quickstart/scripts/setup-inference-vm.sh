#!/bin/bash
echo "==============================="

sudo apt update
sudo apt install -y \
    git \
    curl \
    unzip \
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
echo "Creating Python virtual environment"
echo "==============================="

cd $PROJECT_DIR/workers/inference-worker

python3 -m venv venv
source venv/bin/activate


echo "==============================="
echo "Installing CPU-only PyTorch"
echo "==============================="

pip install torch --index-url https://download.pytorch.org/whl/cpu


echo "==============================="
echo "Installing inference dependencies"
echo "==============================="

pip install -r requirements.txt


echo "==============================="
echo "Inference VM setup complete"
echo "==============================="