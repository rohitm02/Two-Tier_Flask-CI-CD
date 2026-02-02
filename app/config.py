import os


class Config:
    """Configuration class that reads from environment variables"""
    MYSQL_HOST = os.getenv("MYSQL_HOST", "localhost")
    MYSQL_PORT = int(os.getenv("MYSQL_PORT", 3306))
    MYSQL_USER = os.getenv("MYSQL_USER", "todouser")
    MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "todopassword")
    MYSQL_DATABASE = os.getenv("MYSQL_DATABASE", "tododb")
