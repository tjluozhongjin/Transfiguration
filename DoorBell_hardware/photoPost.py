import requests
import os

def post(imagefile):

    url = 'http://60.205.206.174:3000/file'
    files = {'file':open(imagefile,'rb')}
    r = requests.post(url,files = files)
    print r.text
    
if __name__ == '__main__':
    post(imagefile='/home/pi/hci/306/1.jpg')
