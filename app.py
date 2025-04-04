from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Welcome to Software_release_CICD pipeline, \n And this is an Comprehensive SOP on AWS CICD Pipelines'

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
