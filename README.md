cat > /Users/rohit/Documents/code/DevOps/flask-todo-cicd/README.md << 'ENDOFFILE'

# Two-Tier Flask Application with CI/CD

[![Deploy](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/simple-deploy.yml/badge.svg)](https://github.com/rohitm02/Two-Tier_Flask-CI-CD/actions/workflows/simple-deploy.yml)

A two-tier Flask application with MySQL database, fully containerized with Docker and automated CI/CD deployment using GitHub Actions.

## Architecture

\`\`\`
┌──────────────────┐ ┌─────────────────────────┐
│ GitHub Actions │ SSH │ AWS EC2 Instance │
│ Hosted Runner │ ────────>│ <Your-EC2-IP> │
│ │ │ │
│ Build & Deploy │ │ Docker Containers: │
└──────────────────┘ │ ├─ Flask App │
│ └─ MySQL Database │
└─────────────────────────┘
\`\`\`

## Features

- CRUD operations for todo items
- Priority levels (Low, Medium, High)
- Mark todos as complete/incomplete
- Responsive web interface
- Docker containerization
- Automated CI/CD pipeline with GitHub Actions
- Production-ready deployment scripts

## Tech Stack

- **Backend:** Flask (Python)
- **Database:** MySQL 8.0
- **Server:** Gunicorn
- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions
- **Deployment:** AWS EC2

## Project Structure

\`\`\`
flask-todo-cicd/
├── app/ # Flask application
│ ├── db/ # Database connection & initialization
│ ├── routes/ # API routes
│ ├── templates/ # HTML templates
│ ├── static/ # CSS files
│ ├── app.py # Main Flask app
│ ├── config.py # Configuration
│ └── requirements.txt # Python dependencies
├── docker/ # Docker-related files
│ ├── Dockerfile # Flask app container
│ └── entrypoint.sh # Startup script
├── scripts/ # Deployment automation
│ ├── install.sh # Install Docker on EC2
│ ├── start.sh # Start application
│ └── stop.sh # Stop application
├── docker-compose.yml # Multi-container orchestration
└── README.md # Documentation
\`\`\`

## Local Development

### Prerequisites

- Docker Desktop installed
- Git

### Setup

1. Clone the repository:

\`\`\`bash
git clone https://github.com/rohitm02/Two-Tier_Flask-CI-CD.git
cd Two-Tier_Flask-CI-CD
\`\`\`

2. Create environment file:

\`\`\`bash
cp .env.example .env
\`\`\`

3. Start the application:

\`\`\`bash
docker-compose up --build
\`\`\`

4. Access the app at \`http://localhost\`

5. Stop the application:

\`\`\`bash
docker-compose down
\`\`\`

## AWS Deployment

### Prerequisites

- AWS Account
- EC2 instance (Ubuntu 22.04 or Amazon Linux 2)
- Security groups configured:
  - Port 22 (SSH)
  - Port 80 (HTTP)

### Deployment Steps

1. SSH into your EC2 instance:

\`\`\`bash
ssh -i your-key.pem ubuntu@<EC2-IP>
\`\`\`

2. Clone the repository:

\`\`\`bash
git clone https://github.com/rohitm02/Two-Tier_Flask-CI-CD.git
cd Two-Tier_Flask-CI-CD
\`\`\`

3. Run installer script to install Docker:

\`\`\`bash
chmod +x scripts/install.sh
./scripts/install.sh
\`\`\`

4. Log out and log back in for Docker permissions to take effect

5. Create \`.env\` file:

\`\`\`bash
nano .env
\`\`\`

Add the following:
\`\`\`
MYSQL_ROOT_PASSWORD=your_password
MYSQL_DATABASE=todo_db
MYSQL_USER=todo_user
MYSQL_PASSWORD=user_password
MYSQL_PORT=3306
\`\`\`

6. Start the application:

\`\`\`bash
./scripts/start.sh
\`\`\`

7. Access the application at \`http://<EC2-PUBLIC-IP>\`

## GitHub Actions CI/CD

### Setup

1. **Add SSH Private Key to GitHub Secrets:**
   - Navigate to repository Settings → Secrets and variables → Actions
   - Add new secret: \`SSH_PRIVATE_KEY\`
   - Value: Content of your EC2 private key file

2. **Update workflow configuration:**
   - Edit \`.github/workflows/simple-deploy.yml\`
   - Update \`SERVER\` variable with your EC2 IP address
   - Update \`APP_SERVER_DIR\` if using different path

3. **Trigger deployment:**
   \`\`\`bash
   git push origin main
   \`\`\`

### Deployment Process

1. Code is pushed to main branch
2. GitHub Actions runner checks out the code
3. Runner establishes SSH connection to EC2 instance
4. Latest code is pulled on the server
5. Docker containers are rebuilt and restarted
6. Application is live with updated code

## Database Schema

\`\`\`sql
CREATE TABLE todos (
id INT AUTO_INCREMENT PRIMARY KEY,
description VARCHAR(255) NOT NULL,
completed TINYINT(1) DEFAULT 0,
priority VARCHAR(10) DEFAULT 'medium',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
\`\`\`

## API Endpoints

- \`GET /\` - Display all todos
- \`POST /add\` - Add new todo
- \`GET /complete/<id>\` - Mark todo as complete
- \`GET /uncomplete/<id>\` - Mark todo as incomplete
- \`POST /update/<id>\` - Update todo
- \`GET /delete/<id>\` - Delete todo

## Environment Variables

Create \`.env\` file with:

\`\`\`bash
MYSQL_ROOT_PASSWORD=rootpassword123
MYSQL_DATABASE=tododb
MYSQL_USER=todouser
MYSQL_PASSWORD=todopassword
MYSQL_PORT=3306
\`\`\`

## Troubleshooting

**Containers won't start:**

\`\`\`bash
docker-compose logs
\`\`\`

**Permission denied on scripts:**

\`\`\`bash
chmod +x scripts/\*.sh
\`\`\`

**MySQL connection failed:**

- Check \`.env\` file exists
- Verify MySQL container is running: \`docker ps\`

**Port 80 already in use:**

\`\`\`bash
sudo lsof -i :80
\`\`\`

ENDOFFILE
