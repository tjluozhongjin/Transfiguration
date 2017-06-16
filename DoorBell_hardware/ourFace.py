import requests


key = "LiRb3yg8xNdZ26KaaGWpBvocRntnNVpy"
secret = "sfzfdDGKizGtGy9l-1c6-Yys9lz1Etmq"


file = open('/Users/luozhongjin/Desktop/IMG_3961.jpg','rb').read()

files = {
    #'Content-Type': 'multipart/form-data',
    'image_file' : file

}

params = {
    'api_key': key,
    'api_secret': secret,
    'return_attributes':'emotion'
}



res=requests.post('https://api-cn.faceplusplus.com/facepp/v3/detect',params=params,files=files).json()

print res