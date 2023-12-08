from flask import Flask, jsonify
from bd import Db

app = Flask(__name__)
database = Db()

@app.route('/domain-form', methods=['GET'])
def get_domain_forms():
    data = database.fetch_domain_formats()
    return jsonify({'formations': data})

if __name__ == '__main__':
    app.run(debug=True)
