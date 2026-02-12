# Flask Todo App - CI/CD with GitHub Actions

[![Deploy](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/simple-deploy.yml/badge.svg)](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/simple-deploy.yml)

A two-tier Flask application with MySQL database, fully containerized with Docker and automated CI/CD using GitHub Actions.

## 🏗️ Simple Architecture

```
┌──────────────────┐         ┌─────────────────────────┐
│  GitHub Actions  │  SSH    │   AWS EC2 Instance      │
│  (Free Runner)   │────────>│   65.2.128.71           │
│                  │         │                         │
│  Builds & Tests  │         │  🐋 Docker Containers:  │
└──────────────────┘         │   ├─ Flask App          │
                              │   └─ MySQL Database     │
                              └─────────────────────────┘

  Cost: $0/month               Cost: ~$8.50/month
```

**Total monthly cost: ~$8.50** (just one EC2 instance!)

## Features

- CRUD operations for todo items
- Priority levels (Low, Medium, High)
- Mark todos as complete/incomplete
- Beautiful responsive UI
- Docker containerization
- Automated CI/CD pipeline with GitHub Actions
- Production-ready deployment scripts
- Single-server architecture (simple & cost-effective)

## Tech Stack

- **Backend:** Flask (Python)
- **Database:** MySQL 8.0
- **Server:** Gunicorn
- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions (free!)
- **Deployment:** AWS EC2 (single instance)

## Project Structure

```
flask-todo-cicd/
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
│   ├── start.sh            # Start application
│   └── stop.sh             # Stop application
├── docker-compose.yml      # Multi-container orchestration
├── Jenkinsfile             # CI/CD pipeline definition
└── README.md               # This file
```

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
  - Port 8080 (Jenkins) - Your IP only

### Deployment Steps

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

```
http://<EC2-PUBLIC-IP>:8080
```

8. Get Jenkins initial password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Jenkins CI/CD Pipeline

### Setup

1. Create new Pipeline job in Jenkins
2. Configure:
   - **Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** <your-repo-url>
   - **Branch:** \*/main
   - **Script Path:** Jenkinsfile

3. Enable GitHub webhook:
   - GitHub Repo → Settings → Webhooks
   - Payload URL: `http://<EC2-IP>:8080/github-webhook/`
   - Content type: `application/json`
   - Events: Push events

### Pipeline Stages

1. **Checkout Code** - Pull latest from GitHub
2. **Pre-Deployment Check** - Verify scripts
3. **Prepare Environment** - Create .env if missing
4. **Shutdown Existing** - Stop old containers
5. **Deploy Application** - Start new containers

## GitHub Actions CI/CD (Alternative/Additional Pipeline)

### 🚀 Quick Setup

1. **Add SSH Private Key to GitHub Secrets:**
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
| Cost           | EC2 instance    | Free (2000 mins/month) |
| Integration    | Webhook         | Native                 |

📖 **Full setup guide:** [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)

## Database Schema

```sql
CREATE TABLE todos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    completed TINYINT(1) DEFAULT 0,
    priority VARCHAR(10) DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## API Endpoints

- `GET /` - Display all todos
- `POST /add` - Add new todo
- `GET /complete/<id>` - Mark todo as complete
- `GET /uncomplete/<id>` - Mark todo as incomplete
- `POST /update/<id>` - Update todo
- `GET /delete/<id>` - Delete todo

## Environment Variables

Create `.env` file with:

```bash
MYSQL_ROOT_PASSWORD=rootpassword123
MYSQL_DATABASE=tododb
MYSQL_USER=todouser
MYSQL_PASSWORD=todopassword
MYSQL_PORT=3306
```

## Troubleshooting

**Containers won't start:**

```bash
docker-compose logs
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
