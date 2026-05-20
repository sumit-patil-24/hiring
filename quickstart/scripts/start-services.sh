#!/bin/bash

set -e

PROJECT_DIR="$HOME/hiring/may-2026/devops/quickstart"

if [ -z "$1" ]; then
    echo "Usage: ./start-services.sh <API_VM_PRIVATE_IP>"
    exit 1
fi

API_VM_PRIVATE_IP=$1


echo "==============================="
echo "Starting iii engine"
echo "==============================="

cd $PROJECT_DIR

nohup iii --config config.yaml > iii-engine.log 2>&1 &

sleep 5


echo "==============================="
echo "Starting caller-worker"
echo "==============================="

cd $PROJECT_DIR/workers/caller-worker

nohup npm run dev > caller-worker.log 2>&1 &

sleep 5


echo "==============================="
echo "Starting inference-worker"
echo "==============================="

cd $PROJECT_DIR/workers/inference-worker

source venv/bin/activate

export III_URL=ws://$API_VM_PRIVATE_IP:49134

nohup python inference_worker.py > inference-worker.log 2>&1 &

sleep 5


echo "==============================="
echo "All services started"
echo "==============================="

echo "iii engine log:"
echo "$PROJECT_DIR/iii-engine.log"

echo "caller-worker log:"
echo "$PROJECT_DIR/workers/caller-worker/caller-worker.log"

echo "inference-worker log:"
echo "$PROJECT_DIR/workers/inference-worker/inference-worker.log"