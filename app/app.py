from flask import Flask, jsonify
import os, socket, datetime

app = Flask(__name__)

@app.get("/")
def home():
    return jsonify(
        message="TP CI/CD starter - Flask",
        hostname=socket.gethostname(),
        env=os.getenv("APP_ENV", "dev"),
        time=datetime.datetime.utcnow().isoformat() + "Z",
    )

@app.get("/health")
def health():
    return jsonify(
        hostname=socket.gethostname(),
        status="healthy"
    )

if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))
    app.run(host="0.0.0.0", port=port)
