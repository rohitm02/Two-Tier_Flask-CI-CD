# Single Server Deployment Guide

## 🎯 Simplified Architecture - GitHub Actions Only

This guide shows how to deploy your Flask Todo app using **ONE EC2 instance** and **GitHub Actions** (no Jenkins needed!).

---

## 💰 Cost Breakdown

| Component          | Cost             | Notes                                             |
| ------------------ | ---------------- | ------------------------------------------------- |
| GitHub Actions     | **$0**           | Free for public repos, 2000 min/month for private |
| AWS EC2 (t2.micro) | **~$8.50/month** | Single instance for everything                    |
| **TOTAL**          | **~$8.50/month** | vs $26/month with Jenkins!                        |

---

## 🚀 Quick Setup (30 minutes)

### Step 1: Launch Single EC2 Instance

**AWS Console → EC2 → Launch Instance:**

1. **AMI:** Ubuntu 22.04 LTS
2. **Instance Type:** t2.micro (free tier)
3. **Key Pair:** Create/download `.pem` file (save as `flask-todo-key.pem`)
4. **Security Group:**

   ```
   Inbound Rules:
   - SSH (22)      from Your IP
   - HTTP (80)     from Anywhere (0.0.0.0/0)
   ```

   **Note:** No port 8080 needed (Jenkins is gone!)

5. **Launch** and note the **Public IPv4 Address** (e.g., 65.2.128.71)

---

### Step 2: Setup Server

**SSH into your instance:**

```bash
chmod 400 ~/path/to/flask-todo-key.pem
ssh -i ~/path/to/flask-todo-key.pem ubuntu@YOUR_SERVER_IP
```

**Install Docker & Git:**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker ubuntu
newgrp docker

# Verify Docker
docker --version
docker compose version

# Install Git
sudo apt install git -y
```

**Clone your repository:**

```bash
cd ~
git clone https://github.com/rohitm02/Two-Tier_Flask-CI-CD.git
cd Two-Tier_Flask-CI-CD
```

**Create environment file:**

```bash
cp .env.example .env
nano .env  # Edit with your passwords
```

**Test deployment manually:**

```bash
docker compose up -d --build
docker ps  # Should see flask-app and mysql containers
```

**Test app works:**

```bash
curl http://localhost
# Or visit http://YOUR_SERVER_IP in browser
```

---

### Step 3: Configure GitHub Actions

**Add SSH Key to GitHub Secrets:**

1. **Copy your private key:**

   ```bash
   # On your local machine (not EC2)
   cat ~/path/to/flask-todo-key.pem
   ```

2. **Add to GitHub:**
   - Go to: `https://github.com/rohitm02/Two-Tier_Flask-CI-CD/settings/secrets/actions`
   - Click: **New repository secret**
   - Name: `SSH_PRIVATE_KEY`
   - Value: Paste entire key content (including BEGIN/END lines)
   - Click: **Add secret**

**Update workflow file (if needed):**

Edit `.github/workflows/simple-deploy.yml`:

```yaml
env:
  SERVER: YOUR_SERVER_IP # Update to your EC2 IP
```

---

### Step 4: Test Automated Deployment

**Trigger deployment:**

```bash
# On your local machine
git add .
git commit -m "Test deployment"
git push origin main
```

**Watch it deploy:**

1. Go to: `https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions`
2. See your workflow running
3. Click on it to see live logs
4. When complete, visit `http://YOUR_SERVER_IP`

🎉 **Success!** Your app is now auto-deploying on every push!

---

## 🔄 What Happens on Each Push

```
1. You push code to GitHub
   ↓
2. GitHub Actions detects push to main
   ↓
3. Runner checks out your code
   ↓
4. Runner SSHs to your EC2 instance
   ↓
5. Pulls latest code: git pull origin main
   ↓
6. Stops containers: docker compose down
   ↓
7. Rebuilds & starts: docker compose up -d --build
   ↓
8. Verifies: docker ps
   ↓
9. Done! App updated in ~2 minutes
```

---

## 🛠️ Common Operations

### View Container Logs

```bash
ssh ubuntu@YOUR_SERVER_IP
cd ~/Two-Tier_Flask-CI-CD
docker compose logs -f
```

### Restart Containers

```bash
ssh ubuntu@YOUR_SERVER_IP
cd ~/Two-Tier_Flask-CI-CD
docker compose restart
```

### Manual Deployment (no code change)

1. Go to: `Actions` tab in GitHub
2. Click: `Simple Deploy` workflow
3. Click: `Run workflow` button
4. Select: `main` branch
5. Click: `Run workflow`

### Stop Everything

```bash
ssh ubuntu@YOUR_SERVER_IP
cd ~/Two-Tier_Flask-CI-CD
docker compose down
```

### Check Server Resources

```bash
ssh ubuntu@YOUR_SERVER_IP
df -h          # Disk usage
free -h        # Memory usage
docker ps      # Running containers
docker stats   # Real-time resource usage
```

---

## 🔐 Security Checklist

✅ **SSH key permissions:**

```bash
# On local machine
chmod 400 ~/path/to/flask-todo-key.pem
```

✅ **Server security group:**

- Port 22 limited to your IP only
- Port 80 open to internet (app needs to be public)

✅ **Environment variables:**

- Never commit `.env` to Git
- Use strong passwords for MySQL

✅ **Regular updates:**

```bash
ssh ubuntu@YOUR_SERVER_IP
sudo apt update && sudo apt upgrade -y
```

---

## 📊 Verify Deployment is Working

### Check GitHub Actions

```bash
# Green checkmark ✅ = Successful deployment
# Red X ❌ = Failed (click to see logs)
```

### Check Server

```bash
ssh ubuntu@YOUR_SERVER_IP
cd ~/Two-Tier_Flask-CI-CD
docker compose ps  # All should be "Up"
```

### Check Application

```bash
# Should return HTML
curl http://YOUR_SERVER_IP

# Or visit in browser
http://YOUR_SERVER_IP
```

### Check Logs

```bash
docker compose logs flask-app --tail=50
docker compose logs mysql --tail=50
```

---

## 🐛 Troubleshooting

### GitHub Action fails with "Permission denied"

```bash
# Verify SSH key in GitHub Secrets
# Ensure it includes BEGIN/END lines
# Check Security Group allows SSH from GitHub IPs
```

### Containers not starting

```bash
ssh ubuntu@YOUR_SERVER_IP
cd ~/Two-Tier_Flask-CI-CD

# Check logs
docker compose logs

# Often missing .env file
ls -la .env
cp .env.example .env
nano .env  # Add passwords
```

### Port 80 already in use

```bash
ssh ubuntu@YOUR_SERVER_IP

# Find what's using port
sudo lsof -i :80

# If old containers
docker ps -a
docker rm -f $(docker ps -aq)

# Try again
cd ~/Two-Tier_Flask-CI-CD
docker compose up -d --build
```

### App works but shows old code

```bash
# Check if git pull worked
ssh ubuntu@YOUR_SERVER_IP
cd ~/Two-Tier_Flask-CI-CD
git log -1  # Should show latest commit

# Force rebuild
docker compose down
docker compose build --no-cache
docker compose up -d
```

---

## 💡 Advantages of This Setup

### vs Jenkins (Previous Setup)

| Aspect             | Jenkins (Old)           | GitHub Actions (New)     |
| ------------------ | ----------------------- | ------------------------ |
| **Servers**        | 2 EC2 instances         | 1 EC2 instance           |
| **Cost**           | ~$26/month              | ~$8.50/month             |
| **Maintenance**    | Update Jenkins, plugins | Zero (GitHub handles it) |
| **Setup Time**     | 2-3 hours               | 30 minutes               |
| **CI/CD Config**   | Jenkinsfile (Groovy)    | YAML (simpler)           |
| **Logs**           | Jenkins UI              | GitHub UI                |
| **Learning Curve** | Steep                   | Gentle                   |

---

## 🎓 What You're Learning

✅ **CI/CD Fundamentals:**

- Automated deployments
- Git webhooks (native GitHub integration)
- Pipeline as code (YAML)

✅ **Docker in Production:**

- Docker Compose for multi-container apps
- Container networking
- Volume management
- Image rebuilding

✅ **Cloud Deployment:**

- AWS EC2 management
- Security groups
- SSH key management
- Remote server administration

✅ **DevOps Best Practices:**

- Infrastructure as Code
- Automated testing (can add easily)
- Environment separation
- Secret management

---

## 🚀 Next Steps

Once comfortable with this setup:

1. **Add staging environment:** Test before production
2. **Add health checks:** Verify deployments succeed
3. **Add monitoring:** Track uptime and performance
4. **Add automated tests:** Fail fast on bugs
5. **Add rollback:** Quick recovery from bad deploys

---

## 📞 Need Help?

1. **Check GitHub Actions logs** - Most detailed error info
2. **SSH to server** - Check container logs
3. **Review troubleshooting section** - Common issues covered

---

**You now have a production-ready, auto-deploying Flask app for less than $10/month!** 🎉
