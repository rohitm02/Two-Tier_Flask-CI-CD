from flask import Flask

from app.db.mysql import init_db
from app.routes.main import main


def create_app():
    """Create and configure the Flask application"""
    app = Flask(__name__)
    app.register_blueprint(main)
    return app


app = create_app()

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000, debug=True)
