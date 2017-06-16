import requests
import json

def postConfidence(confidence):
    url = "http://60.205.206.174:3000/data"
    headers = {
        'Content-Type':'application/json'
    }
    d = {
        'confidence':confidence
    }
    requests.post(url,headers = headers, data = json.dumps(d))



if __name__ == '__main__':
    postConfidence(0.8)
