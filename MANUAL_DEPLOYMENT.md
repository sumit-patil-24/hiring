# Manual AWS Deployment Walkthrough

## 1. Created AWS Infrastructure

### Created:

* VPC
* public subnet
* private subnet
* internet gateway
* NAT gateway
* route tables
* security groups
* API VM
* inference VM

---

# 2. VPC Design

## CIDR

```text
VPC:               10.0.0.0/16
Public subnet:     10.0.1.0/24
Private subnet:    10.0.2.0/24
```

---

# 3. Public Subnet

Contains:

* API VM
* NAT Gateway

Route table:

```text
0.0.0.0/0 → Internet Gateway
```

---

# 4. Private Subnet

Contains:

* inference VM

Route table:

```text
0.0.0.0/0 → NAT Gateway
```

Purpose:

* outbound internet access
* no public inbound access

---

# 5. Security Groups

## API VM Security Group

Allowed:

* SSH from my IP
* TCP 3111 from internet
* TCP 49134 from VPC/private subnet

---

## Inference VM Security Group

Allowed:

* SSH only from API VM security group

No public inbound access allowed.

---

# 6. Connected to API VM

```bash
ssh -i mykey.pem ubuntu@PUBLIC_IP
```

---

# 7. Installed iii Engine

```bash
curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc
```

---

# 8. Verified iii Installation

```bash
iii --version
```

---

# 9. Cloned Repository

```bash
git clone https://github.com/sumit-patil-24/hiring.git

cd hiring/quickstart
```

---

# 10. Started iii Engine

```bash
iii --config config.yaml
```

Expected:

* engine listening on port 49134

---

# 11. Setup Caller Worker

```bash
cd workers/caller-worker

sudo apt install npm -y

npm install

npm run dev
```

Expected:

* caller-worker started

---

# 12. Connected to Inference VM Through API VM

Copied PEM:

```bash
scp -i mykey.pem mykey.pem ubuntu@PUBLIC_IP:/home/ubuntu/
```

SSH from API VM:

```bash
ssh -i mykey.pem ubuntu@PRIVATE_IP
```

---

# 13. Setup Inference Worker

```bash
sudo apt install python3.14-venv -y

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt
```

---

# 14. Connected Worker to iii Engine

```bash
export III_URL=ws://10.0.1.X:49134
```

---

# 15. Started Inference Worker

```bash
python inference_worker.py
```

Expected:

* inference worker connected successfully

---

# 16. Verified RPC Communication

Request flow:

```text
curl request
    ↓
caller-worker
    ↓
iii engine
    ↓
inference-worker
    ↓
Gemma inference
    ↓
JSON response
```

---

# 17. Tested Public API

```bash
curl -X POST http://PUBLIC_IP:3111/v1/chat/completions \
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

# 18. Final Working Architecture

```text
Internet
   │
   ▼
[ API VM ]
   ├── iii engine
   ├── caller-worker
   ├── public HTTP API
   │
   ▼
[ Inference VM ]
   ├── inference-worker
   ├── Gemma model
```
