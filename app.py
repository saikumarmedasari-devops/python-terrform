
from flask import Flask, jsonify, request

app = Flask(__name__)

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

@app.route("/")
def home():
    return """
    <h1>Python Calculator</h1>
    <h2>Successfully deployed on AWS EC2!</h2>
    <p>Infrastructure managed by Terraform.</p>
    """

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

@app.route("/calculate")
def calculate():
    try:
        a = float(request.args.get("a"))
        b = float(request.args.get("b"))
        operation = request.args.get("operation")

        operations = {
            "add": add,
            "subtract": subtract,
            "multiply": multiply,
            "divide": divide
        }

        if operation not in operations:
            return jsonify({"error": "Invalid operation"}), 400

        result = operations[operation](a, b)
        return jsonify({"result": result})

    except (TypeError, ValueError) as error:
        return jsonify({"error": str(error)}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

