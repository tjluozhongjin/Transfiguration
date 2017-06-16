import requests
import json

def postLock():
    url = 'http://60.205.206.174:3000/unlock'
    headers = {
        'Content-Type':'application/json'
    }
    d = {
        'unlock':'false'
    }
    requests.post(url,headers = headers, data = json.dumps(d))





