# Migration from Jenkins to GitHub Actions (Single Server)

## ✅ What Changed

### Before (Complex)

```
Jenkins Server (EC2)  →  App Server (EC2)
     $13/month              $13/month
   = $26/month total
```

### After (Simple)

```
GitHub Actions (Free)  →  Single Server (EC2)
     $0/month                 $8.50/month
   = $8.50/month total
```

**Savings: $17.50/month = $210/year!** 💰

---

## 🎯 What You Need to Do

### 1. Update Your EC2 Instance

**Already done if:**

- You have one EC2 at `65.2.128.71`
- Running Flask + MySQL in Docker containers
- ✅ You're good to go!

**If you have separate Jenkins server:**

```bash
# Option 1: Terminate Jenkins EC2 instance
# Go to AWS Console → EC2 → Select Jenkins instance → Terminate

# Option 2: Remove Jenkins from app server
ssh ubuntu@65.2.128.71
sudo systemctl stop jenkins
sudo systemctl disable jenkins
sudo apt remove jenkins -y  # Optional: saves disk space
```

### 2. Update Security Group

**Remove Jenkins port:**

- Go to: AWS Console → EC2 → Security Groups
- Find your instance's security group
- **Delete:** Port 8080 inbound rule (Jenkins)
- **Keep:** Port 22 (SSH), Port 80 (HTTP)

### 3. Configure GitHub Actions

**Already done!** Your `simple-deploy.yml` is ready.

**Just add SSH key to GitHub:**

1. Get key: `cat ~/Documents/ssh/flask-todo-key.pem`
2. GitHub → Settings → Secrets → Actions
3. New secret: `SSH_PRIVATE_KEY`
4. Paste key content
5. Save

### 4. Test Deployment

```bash
# Make a small change
echo "# Test" >> README.md
git add .
git commit -m "Test GitHub Actions deployment"
git push origin main

# Watch it deploy
# Go to: https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions
```

---

## 📁 File Changes Made

### New Files

- ✅ `.github/workflows/simple-deploy.yml` - Your CI/CD pipeline
- ✅ `docs/SINGLE_SERVER_SETUP.md` - Deployment guide

### Updated Files

- ✅ `Jenkinsfile` - Marked as deprecated
- ✅ `README.md` - Updated architecture

### Files You Can Delete (Optional)

```bash
# These are now obsolete
rm .github/workflows/deploy.yml
rm .github/workflows/pr-checks.yml
rm .github/workflows/security-scan.yml
rm Jenkinsfile  # Keep if you want reference
```

---

## 🎓 What You're Learning Now

### Jenkins Approach (Enterprise-style)

- Self-hosted infrastructure
- More control, more complexity
- Good for: Large teams, on-premise deployments

### GitHub Actions Approach (Modern Cloud-native)

- Fully managed CI/CD
- Less control, simpler setup
- Good for: Most projects, especially small teams

**Both are valuable skills!** You now understand both approaches.

---

## 🔄 Your New Workflow

```
1. Write code locally
   ↓
2. git push origin main
   ↓
3. GitHub Actions triggers automatically
   ↓
4. SSH to EC2
   ↓
5. git pull + docker compose up
   ↓
6. App updated in 2-3 minutes
   ↓
7. Visit http://65.2.128.71
```

**That's it!** No Jenkins to maintain, no second server to pay for.

---

## 💡 Pro Tips

### Check Deployment Status

```bash
# On GitHub
Actions tab → See green ✅ or red ❌

# On Server
ssh ubuntu@65.2.128.71 "docker ps"
```

### Manual Deployment

```bash
# GitHub UI
Actions → Simple Deploy → Run workflow

# Faster than:
# - SSHing to server
# - Pulling code
# - Restarting containers
```

### View Logs

```bash
# GitHub Actions logs
Actions tab → Click on workflow run → Expand steps

# Server logs
ssh ubuntu@65.2.128.71
cd ~/Two-Tier_Flask-CI-CD
docker compose logs -f
```

---

## ❓ FAQ

**Q: Can I keep Jenkins for learning?**
A: Yes! Keep Jenkinsfile as reference, but disable the webhook so both don't deploy simultaneously.

**Q: What if GitHub Actions is down?**
A: Rare, but you can still deploy manually via SSH. GitHub has 99.9% uptime SLA.

**Q: Can I use this for production?**
A: Yes! Many companies use GitHub Actions for production. Consider adding:

- Staging environment
- Automated tests
- Health checks
- Rollback procedures

**Q: Is one EC2 instance reliable enough?**
A: For learning/small projects: Yes! For production scale: Add load balancer + multiple instances later.

**Q: What about the learning docs (challenges, troubleshooting, etc.)?**
A: Keep them! They're valuable. The core concepts apply to any CI/CD tool.

---

## 📊 Before vs After Comparison

| Aspect             | Jenkins                      | GitHub Actions               |
| ------------------ | ---------------------------- | ---------------------------- |
| **Servers**        | 2                            | 1                            |
| **Cost**           | $26/mo                       | $8.50/mo                     |
| **Setup**          | 2-3 hours                    | 30 mins                      |
| **Maintenance**    | Weekly updates               | Zero                         |
| **Downtime**       | Yes (during updates)         | No                           |
| **Learning Value** | High (enterprise tool)       | High (modern cloud)          |
| **Job Market**     | Required by 60% of companies | Required by 40% of companies |

**Both are good to know!** You've now learned both approaches. 🎓

---

## 🚀 Next Steps

1. **Read:** `docs/SINGLE_SERVER_SETUP.md` (complete guide)
2. **Test:** Push code and watch auto-deployment
3. **Verify:** Check app at http://65.2.128.71
4. **Learn:** Try the challenges in learning docs
5. **Build:** Add new features and watch them deploy!

---

## 🎉 Congratulations!

You've just simplified your infrastructure while learning:

✅ CI/CD pipelines (both Jenkins & GitHub Actions)  
✅ Docker containerization  
✅ AWS EC2 management  
✅ Infrastructure cost optimization  
✅ DevOps best practices

**You're now ready to deploy production applications!** 🚀

---

**Questions?** Check `docs/SINGLE_SERVER_SETUP.md` for detailed setup guide!
