# GitHub Actions Setup Guide

## 🚀 Setting Up GitHub Actions for Your Flask Todo App

This guide will help you migrate from Jenkins to GitHub Actions (or run both in parallel).

## Prerequisites

1. GitHub repository with admin access
2. AWS EC2 instance with your application
3. SSH private key for EC2 access

## Step 1: Add GitHub Secrets

Navigate to your repository: **Settings → Secrets and variables → Actions → New repository secret**

### Required Secrets:

1. **SSH_PRIVATE_KEY**

   ```bash
   # Copy your private key content
   cat ~/Documents/ssh/flask-todo-key.pem
   ```

   - Name: `SSH_PRIVATE_KEY`
   - Value: Paste the entire content (including BEGIN/END lines)

2. **APP_SERVER_HOST** (Optional - already in workflow env)
   - Name: `APP_SERVER_HOST`
   - Value: `65.2.128.71`

3. **MYSQL_ROOT_PASSWORD** (if needed for .env)
   - Name: `MYSQL_ROOT_PASSWORD`
   - Value: Your MySQL password

### Optional Secrets for Advanced Features:

4. **DOCKER_USERNAME** (if pushing to Docker Hub)
5. **DOCKER_PASSWORD**
6. **SLACK_WEBHOOK_URL** (for notifications)

## Step 2: Update Workflow Configuration

Edit [.github/workflows/deploy.yml](.github/workflows/deploy.yml):

```yaml
env:
  APP_SERVER_HOST: 65.2.128.71 # Update with your EC2 IP
  APP_SERVER_USER: ubuntu # Update if different
  APP_SERVER_DIR: /home/ubuntu/Two-Tier_Flask-CI-CD # Update path
```

## Step 3: Enable GitHub Actions

1. Go to **Actions** tab in your repository
2. Click "I understand my workflows, go ahead and enable them"
3. Workflows will now trigger on push to main branch

## Step 4: Test the Workflow

### Method 1: Push to Main

```bash
git add .
git commit -m "Enable GitHub Actions"
git push origin main
```

### Method 2: Manual Trigger

1. Go to **Actions** tab
2. Select "CI/CD Pipeline - Deploy Flask Todo App"
3. Click **Run workflow** → **Run workflow**

## Step 5: Monitor Workflow Execution

1. Go to **Actions** tab
2. Click on the running workflow
3. View real-time logs for each job and step

## Workflow Files Explained

### 1. `deploy.yml` - Main CI/CD Pipeline

- **Trigger**: Push to main branch
- **Jobs**:
  - `build-and-test`: Validates code and builds Docker image
  - `deploy`: Deploys to AWS EC2 via SSH
  - `security-scan`: Scans for vulnerabilities

### 2. `pr-checks.yml` - Pull Request Validation

- **Trigger**: When PR is opened/updated
- **Purpose**: Validate code quality before merging
- **Features**: Linting, testing, Docker build validation

## Comparing with Your Jenkins Setup

| Feature           | Jenkins                 | GitHub Actions         |
| ----------------- | ----------------------- | ---------------------- |
| **Trigger**       | Webhook                 | Native Git events      |
| **Configuration** | Jenkinsfile (Groovy)    | YAML workflows         |
| **Runners**       | Your EC2 instance       | GitHub-hosted (free)   |
| **Maintenance**   | Update Jenkins, plugins | Zero maintenance       |
| **Cost**          | EC2 + bandwidth         | Free (2000 mins/month) |
| **Secrets**       | Jenkins credentials     | GitHub Secrets         |

## Advanced Features

### 1. Add Slack Notifications

Add to the end of deploy job:

```yaml
- name: Notify Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### 2. Deploy to Multiple Environments

Create separate workflows for staging/production:

```yaml
# .github/workflows/deploy-staging.yml
on:
  push:
    branches: [ develop ]

# .github/workflows/deploy-production.yml
on:
  release:
    types: [ published ]
```

### 3. Scheduled Health Checks

```yaml
name: Daily Health Check

on:
  schedule:
    - cron: "0 9 * * *" # Run at 9 AM daily

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check Application Health
        run: |
          curl -f http://65.2.128.71/health || exit 1
```

### 4. Docker Image Publishing

```yaml
- name: Log in to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

- name: Build and Push
  uses: docker/build-push-action@v5
  with:
    push: true
    tags: rohitm02/flask-todo:${{ github.sha }}
```

## Troubleshooting

### SSH Connection Issues

```bash
# Test SSH from GitHub Actions
- name: Test SSH
  run: |
    ssh -i ~/.ssh/deploy_key -o StrictHostKeyChecking=no \
      ubuntu@65.2.128.71 "echo 'SSH connection successful'"
```

### Permission Denied

Ensure your EC2 instance allows GitHub Actions IPs:

```bash
# On EC2, check security group allows SSH from anywhere
# Or add GitHub Actions IP ranges to security group
```

### Workflow Not Triggering

1. Check `.github/workflows/` directory exists
2. Verify YAML syntax: Use [YAML Validator](https://www.yamllint.com/)
3. Check branch name matches trigger condition

### View Detailed Logs

1. Enable debug logging:
   - Settings → Secrets → Add `ACTIONS_STEP_DEBUG` = `true`
   - Settings → Secrets → Add `ACTIONS_RUNNER_DEBUG` = `true`

## Migration Strategy

### Option 1: Parallel Run (Recommended)

- Keep Jenkins running
- Enable GitHub Actions
- Monitor both for 1-2 weeks
- Disable Jenkins after validation

### Option 2: Direct Switch

- Disable Jenkins webhook
- Enable GitHub Actions
- Monitor first few deployments closely

## Benefits of GitHub Actions

✅ **Zero Infrastructure**: No Jenkins server to maintain
✅ **Native Integration**: Works seamlessly with GitHub
✅ **Free Tier**: 2000 minutes/month for private repos
✅ **Faster Setup**: Ready in 5 minutes vs hours for Jenkins
✅ **Better Secrets Management**: Encrypted, version-controlled
✅ **Marketplace**: 10,000+ pre-built actions
✅ **Matrix Builds**: Test on multiple OS/versions simultaneously
✅ **Caching**: Built-in dependency caching

## Next Steps

1. ✅ Add secrets to GitHub
2. ✅ Test workflow with manual trigger
3. ✅ Push code and verify auto-deployment
4. 📝 Add status badge to README:

```markdown
[![CI/CD Pipeline](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/deploy.yml/badge.svg)](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/deploy.yml)
```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners) (if you want to use your EC2 as runner)

## Support

Need help? Open an issue or check the Actions tab for logs and error messages.
