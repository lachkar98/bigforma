from flask import Flask, jsonify, request
from bd import Db
app = Flask(__name__)

database = Db()

@app.route('/domain-form', methods=['GET'])
def get_domain_forms():
    database.fetch_domain_formats()
    data = {'response': 'les donnees sont affichee sur votre console python'}
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
