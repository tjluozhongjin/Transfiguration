# -*- coding: utf-8 -*-
import requests
import time

def compare(imageFile1,imageFile2):
    url = 'https://api-cn.faceplusplus.com/facepp/v3/compare'
    params = {
        'api_key': 'LiRb3yg8xNdZ26KaaGWpBvocRntnNVpy',
        'api_secret': 'sfzfdDGKizGtGy9l-1c6-Yys9lz1Etmq',
        #'face_token1': '3fdaa6565839b62f04aa5e50ae7bb906',
        #'face_token1':'3fdaa6565839b62f04aa5e50ae7bb906',
        #'face_token2':'a95d7aa4fd9a9d95ba380f0fcffb3a74'
    }

    file1 = open(imageFile1,'rb').read()
    file2 = open(imageFile2,'rb').read()
    files = {
        #'face_token1':'5f76bf2ae866807d807035b36d620020',
        #'Content-Type': 'multipart/form-data',
        'image_file1' : file1,
        'image_file2' : file2
    }
    #params['face_token1'] = 'jczoJU0H7cFzfMG7kzUN8A=='
    #params['face_token2'] = 'ZvCIHuDaJxxqMXyhHqtqig=='
    a = time.time()
    r = requests.post(url, params=params,files=files)
    b = time.time()
    j = r.json()

    #print j
    #print b-a
    return j


if __name__ == '__main__':
    imageFile1 = '/Users/luozhongjin/Desktop/IMG_3546.jpg'
    imageFile2 = '/Users/luozhongjin/Desktop/IMG_3919.jpg'
    compare(imageFile1=imageFile1,imageFile2=imageFile2)