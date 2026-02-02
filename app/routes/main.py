from flask import Blueprint, redirect, render_template, request

from app.db.mysql import get_connection

main = Blueprint("main", __name__)


@main.route("/")
def index():
    """Display all todos"""
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM todos ORDER BY created_at DESC")
    todos = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template("index.html", todos=todos)


@main.route("/add", methods=["POST"])
def add_todo():
    """Add a new todo"""
    description = request.form["description"]
    priority = request.form.get("priority", "medium")

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO todos (description, priority) VALUES (%s, %s)",
        (description, priority)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/")


@main.route("/complete/<int:todo_id>")
def complete_todo(todo_id):
    """Mark a todo as completed"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE todos SET completed = 1 WHERE id = %s",
        (todo_id,)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/")


@main.route("/incomplete/<int:todo_id>")
def uncomplete_todo(todo_id):
    """Mark a todo as not completed"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE todos SET completed = 0 WHERE id = %s",
        (todo_id,)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/")


@main.route("/delete/<int:todo_id>")
def delete_todo(todo_id):
    """Delete a todo"""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM todos WHERE id = %s", (todo_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/")


@main.route("/update/<int:todo_id>", methods=["POST"])
def update_todo(todo_id):
    """Update todo description and priority"""
    description = request.form["description"]
    priority = request.form["priority"]

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE todos SET description=%s, priority=%s WHERE id=%s",
        (description, priority, todo_id)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/")
