# Project Quickstart Guide

This repository contains the infrastructure and worker configurations to run the application both locally and on AWS using Terraform.

## Assignment Objective

This project demonstrates:
- distributed worker communication over RPC
- private subnet isolation
- public API exposure
- infrastructure-as-code provisioning
- reproducible cloud deployment

---

## Steps to Run the Application Locally

Follow these steps to set up the engine, inference workers, and caller workers on your local environment.

### 1. Install the `iii` Engine

Run the installation script and update your system path:

```bash
curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

```

### 2. Verify Installation

Ensure the binary is correctly installed:

```bash
iii --version

```

### 3. Clone the Repository

Clone the codebase and navigate to the quickstart directory:

```bash
git clone https://github.com/sumit-patil-24/hiring.git
cd hiring/quickstart

```

### 4. Start the Engine

Launch the core engine using the provided configuration file:

```bash
iii --config config.yaml

```

### 5. Start the Inference Worker

Open a new terminal session, set up the Python virtual environment, install dependencies, and start the worker:

```bash
cd workers/inference-worker
sudo apt install python3.14-venv -y
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

python inference_worker.py

```

**Expected Output:**

> `Inference worker started - listening for calls`

### 6. Start the Caller Worker

Open another new terminal session, install the Node packages, and run the development server:

```bash
cd workers/caller-worker
sudo apt install npm -y
npm install
npm run dev

```

**Expected Output:**

> `Caller worker started`

### 7. Test the System

Verify everything is routing correctly by triggering a test request via `curl`:

```bash
curl -X POST http://localhost:3111/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{
  "messages": [
    {
      "role": "user",
      "content": "Hello"
    }
  ]
}'

```

---

## Steps to Deploy on AWS Using Terraform

Follow these steps to provision the required cloud infrastructure using Terraform.

### 1. Clone the Repository

If you haven't already, clone the repository and switch to the Terraform directory:

```bash
git clone https://github.com/sumit-patil-24/hiring.git  
cd hiring/quickstart/terraform

```

### 2. Configure Variables

Create your variable definition file from the provided example and update it with your configuration (such as region, subnets, and your public IP):

```bash
cp terraform.tfvars.example terraform.tfvars

```

### 3. Initialize and Deploy Infrastructure

Run the standard Terraform workflow to apply the architecture changes:

```bash
# Initialize the backend and providers
terraform init

# Validate the syntax configuration
terraform validate

# Review the execution plan
terraform plan 

# Provision the AWS infrastructure
terraform apply 

```


## architecture of VPC
 - VPC
 - public subnet
 - private subnet
 - nat gateway
 - internet gateway
 - t3.medium instance on public subnet
 - t3.large instance  on private subnet
 - route tables
   
<img width="1541" height="423" alt="Screenshot 2026-05-20 124123" src="https://github.com/user-attachments/assets/f4abf20e-87ed-41d4-be61-7d3464fdf0ed" />

## network flow of request
```
Internet
   │
   ▼
[ Public API VM ]
   ├── iii Engine
   ├── caller-worker
   ├── HTTP API :3111
   │
   │ RPC over private subnet
   ▼
[ Private Inference VM ]
   ├── inference-worker
   ├── Gemma 3 270M
   └── transformers inference

Private VM outbound internet:
Private VM → NAT Gateway → Internet Gateway
```

## instances running
<img width="1579" height="368" alt="Screenshot 2026-05-20 124352" src="https://github.com/user-attachments/assets/1950e70d-f177-47ed-8328-21c5fe30e7cf" />

## running interface worker
<img width="1769" height="366" alt="Screenshot 2026-05-20 124333" src="https://github.com/user-attachments/assets/1eeb60be-0b7b-43f9-804b-a07bde744bcb" />

## running caller worker
<img width="1156" height="433" alt="Screenshot 2026-05-20 124313" src="https://github.com/user-attachments/assets/b9c7821c-4067-4c63-b7d2-bf9e3d64c08f" />

## running **iii --config config.yaml** command
<img width="1001" height="240" alt="Screenshot 2026-05-20 124225" src="https://github.com/user-attachments/assets/6edb1d0a-9ac6-4c90-b03c-36ec31637ad0" />

## making curl request
<img width="1770" height="437" alt="Screenshot 2026-05-20 124146" src="https://github.com/user-attachments/assets/614e44c3-6759-48fb-a140-2e63f383e5c9" />
