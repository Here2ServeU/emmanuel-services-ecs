from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__, static_url_path='/static')

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/')
def serve_template_image(filename):
    return send_from_directory(os.path.join(app.root_path, 'templates'), filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050, debug=True)