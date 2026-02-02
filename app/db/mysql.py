import mysql.connector
from mysql.connector import Error

from app.config import Config


def get_connection():
    """Create and return a MySQL database connection"""
    return mysql.connector.connect(
        host=Config.MYSQL_HOST,
        port=Config.MYSQL_PORT,
        user=Config.MYSQL_USER,
        password=Config.MYSQL_PASSWORD,
        database=Config.MYSQL_DATABASE,
    )


def init_db():
    """Initialize the database - create todos table if it doesn't exist"""
    try:
        conn = get_connection()
        cursor = conn.cursor()

        # Create the todos table based on your schema
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS todos (
                id INT AUTO_INCREMENT PRIMARY KEY,
                description VARCHAR(255) NOT NULL,
                completed TINYINT(1) DEFAULT 0,
                priority VARCHAR(10) DEFAULT 'medium',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)

        conn.commit()
        cursor.close()
        conn.close()
        print("[DB INFO] Database initialized successfully")
    except Error as e:
        print(f"[DB ERROR] {e}")
