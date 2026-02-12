# Two-Tier Flask Application with CI/CD

[![Deploy](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/simple-deploy.yml/badge.svg)](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/simple-deploy.yml)

A two-tier Flask application with MySQL database, fully containerized with Docker and automated CI/CD deployment using GitHub Actions.

## Architecture

```
┌──────────────────┐         ┌─────────────────────────┐
│  GitHub Actions  │  SSH    │   AWS EC2 Instance      │
│  Hosted Runner   │────────>│   65.2.128.71           │
│                  │         │                         │
│  Build & Deploy  │         │  Docker Containers:     │
└──────────────────┘         │   ├─ Flask App          │
                              │   └─ MySQL Database     │
                              └─────────────────────────┘
```

## Features

- CRUD operations for todo items
- Priority levels (Low, Medium, High)
- Mark todos as complete/incomplete
- Beautiful responsive UI
- Docker containerization
- Automated CI/CD pipeline with GitHub Actions
- Production-ready deployment scripts
- Responsive web interface
- Docker containerization
- Automated CI/CD pipeline with GitHub Actions
- Production-ready deployment scripts
- **Database:** MySQL 8.0
- **Server:** Gunicorn
- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions (free!)
- **Deployment:** AWS EC2 (single instance)

## Project Structure

```
- **Deployment:** AWS EC2
├── app/                    # Flask application
│   ├── db/                 # Database connection & initialization
│   ├── routes/             # API routes
│   ├── templates/          # HTML templates
│   ├── static/             # CSS files
│   ├── app.py              # Main Flask app
│   ├── config.py           # Configuration
│   └── requirements.txt    # Python dependencies
├── docker/                 # Docker-related files
│   ├── Dockerfile          # Flask app container
│   └── entrypoint.sh       # Startup script
├── scripts/                # Deployment automation
│   ├── install.sh          # Install Docker, Jenkins on EC2
│   ├── start.sh            # Start applicat on EC2
│   ├── start.sh            # Start application
│   └── stop.sh             # Stop application
├── docker-compose.yml      # Multi-container orchestration
└── README.md               # Documentation

## Local Development

### Prerequisites

- Docker Desktop installed
- Git

### Setup

1. Clone the repository:

```bash
git clone <your-repo-url>
cd flask-todo-cicd
```

2. Create environment file:

```bash
cp .env.example .env
```

3. Start the application:

```bash
docker-compose up --build
```

4. Access the app:

```
http://localhost
```

5. Stop the application:

```bash
docker-compose down
```

## AWS Deployment

### Prerequisites

- AWS Account
- EC2 instance (Ubuntu/Amazon Linux)
- Security groups configured:
  - Port 22 (SSH) - Your IP only
  - Port 80 (HTTP) - Public
  - Port 8080 (Je
  - Port 80 (HTTP)

1. SSH into EC2 instance

2. Clone the repository:

```bash
git clone <your-repo-url>
cd flask-todo-cicd
```

3. Run installer script:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

4. Log out and log back in (for Docker permissions)

5. Create `.env` file:

```bash
cp .env.example .env
```

6. Start the application:

```bash
./scripts/start.sh
```

7. Access Jenkins:

```the application at `http://<EC2-PUBLIC-IP>`

## GitHub Actions CI/CD

### Private Key to GitHub Secrets:**
   - Go to: `Settings → Secrets and variables → Actions`
   - Add secret: `SSH_PRIVATE_KEY`
   - Value: Content of your `.pem` file

2. **Update workflow configuration:**
   - Edit [.github/workflows/deploy.yml](.github/workflows/deploy.yml)
   - Set your EC2 IP in `APP_SERVER_HOST`

3. **Push to trigger deployment:**
   ```bash
   git push origin main
   ```

### Workflow Features

✅ **Automated on every push to main**  
✅ **Build validation & testing**  
✅ **Security vulnerability scanning**  
✅ **Docker image building**  
✅ **Remote deployment via SSH**  
✅ **PR checks for code quality**  
✅ **Zero infrastructure cost** (uses GitHub-hosted runners)

### Available Workflows

| Workflow            | Trigger          | Purpose                         |
| ------------------- | ---------------- | ------------------------------- |
| `deploy.yml`        | Push to main     | Build & deploy to production    |
| `pr-checks.yml`     | Pull request     | Validate code quality           |
| `security-scan.yml` | Push/PR/Schedule | Security vulnerability scanning |

### GitHub Actions vs Jenkins

| Feature        | Jenkins         | GitHub Actions         |
| -------------- | --------------- | ---------------------- |
| Setup Time     | 30-60 minutes   | 5 minutes              |
| Infrastructure | Self-hosted EC2 | GitHub-hosted (free)   |
| Maintenance    | Required        | Zero                   |
| CosNavigate to repository Settings → Secrets and variables → Actions
   - Add new secret: `SSH_PRIVATE_KEY`
   - Value: Content of your EC2 private key file

2. **Update workflow configuration:**
   - Edit `.github/workflows/simple-deploy.yml`
   - Update `SERVER` variable with your EC2 IP address
   - Update `APP_SERVER_DIR` if using different path

3. **Trigger deployment:**
   ```bash
   git push origin main
   ```

### Workflow Features

- Automated deployment on every push to main branch
- SSH-based deployment to EC2 instance
- Docker container orchestration
- Manual trigger option available
- `GET /uncomplete/<id>` - Mark todo as incomplete
- `POST /update/<id>` - Update todo
- `GET /delete/<id>` - Delete todo
Deployment Process

1. Code is pushed to main branch
2. GitHub Actions runner checks out the code
3. Runner establishes SSH connection to EC2 instance
4. Latest code is pulled on the server
5. Docker containers are rebuilt and restarted
6. Application is live with updated code
```

**Permission denied on scripts:**

```bash
chmod +x scripts/*.sh
```

**MySQL connection failed:**

- Check `.env` file exists
- Verify MySQL container is running: `docker ps`

**Port 80 already in use:**

```bash
sudo lsof -i :80
# Kill the process or change port in docker-compose.yml
```

## Future Enhancements

- [ ] Add unit tests with pytest
- [ ] Implement user authentication (JWT)
- [ ] Push Docker images to registry
- [ ] Set up monitoring (Prometheus/Grafana)
- [ ] Add resource limits in docker-compose
- [ ] Implement blue-green deployment
- [ ] Add multiple environments (dev/staging/prod)
- [ ] Kubernetes manifests for orchestration
- [ ] Add database migrations with Alembic
- [ ] Implement CI/CD notifications (Slack/Email)

## Author

DevOps Learning Project

## License

MIT License
Add unit tests with pytest
- Implement user authentication
- Push Docker images to container registry
- Set up monitoring and logging
- Add resource limits in docker-compose
- Implement blue-green deployment strategy
- Add multiple environments (dev/staging/prod)
- Database migrations with Alembic
- CI/CD notifications