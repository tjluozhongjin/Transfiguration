import requests
import ourCompare


key = "LiRb3yg8xNdZ26KaaGWpBvocRntnNVpy"
secret = "sfzfdDGKizGtGy9l-1c6-Yys9lz1Etmq"

def analyze(face_token):

    # file = open('/Users/luozhongjin/Desktop/IMG_3546.jpg','rb').read()
    #
    # files = {
    #     #'Content-Type': 'multipart/form-data',
    #     #'image_file' : file
    #     #'face_token':'bd2819827b82b2c7dc15a54da643b632'
    #
    # }

    params = {
        'api_key': key,
        'api_secret': secret,
        'return_attributes':'emotion',
        'face_tokens':[face_token]
    }



    res=requests.post('https://api-cn.faceplusplus.com/facepp/v3/face/analyze',params=params).json()

    return res

if __name__ == '__main__':
    analyze('60f568343eb7bc1b71f578b5f6a77e76')