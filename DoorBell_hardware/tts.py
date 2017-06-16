#!/usr/bin/env python3
# coding: utf-8

import json
import os
import signal
import subprocess
import sys
import uuid
import wave


import pyaudio
import pygame
import requests
import time
#from playsound import playsound
CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 8000
# RECORD_SECONDS = 5
WAVE_OUTPUT_FILENAME = "output.wav"

# 在此输入百度语音API Key和Secret Key
apikey = "aPXjLjbE2wRrj3FjzQl9XtxK"
secret = "f63c6d09bf430b18cd51cd5a0a9d6c54"

p = None
stream = None
frames = []


def _retrieve_token(api_key, secret_key):
    '''
    向百度服务器获取token，返回token
    参数：
        api_key - API Key
        secret_key - Secret Key
    '''
    data = {"grant_type": "client_credentials", "client_id": api_key, "client_secret": secret_key}
    r = requests.post("https://openapi.baidu.com/oauth/2.0/token", data)
    j = json.loads(r.text)
    token = j["access_token"]
    tokenfile = open(os.getcwd() + "/token.save", "w")
    tokenfile.write(token)
    tokenfile.close()
    return token


def get_token():
    '''
    百度应用token获取，检查历史token记录
    无参数
    '''
    if os.path.exists("token.save"):
        tokenfile = open(os.getcwd() + "/token.save", "r")
        token = tokenfile.read()
        tokenfile.close()
        return token
    else:
        return _retrieve_token(apikey, secret)


def get_mac_address():
    '''
    获取本机MAC地址作为唯一识别码
    '''
    mac = uuid.UUID(int=uuid.getnode()).hex[-12:]
    return ":".join([mac[e:e + 2] for e in range(0, 11, 2)])


def get_baidu_voice(text, lang="zh", speed=5, pitch=5, volumn=5, person=0):
    '''
    百度语音合成，成功保存和播放二进制mp3文件，失败打印错误码
    参数：
        text - 要合成文本
        lang - 语言，默认中文
        speed - 语速，取值0-9，默认5
        pitch - 语调，同上
        volumn - 音量，同上
        person - 取值0或1，0为女性，1为男性，默认女性
    '''
    token = get_token()
    mac = get_mac_address()
    r = requests.get(
        "http://tsn.baidu.com/text2audio?tex=%s&lan=%s&cuid=%s&ctp=1&tok=%s&spd=%d&pit=%d&vol=%d&per=%d" % (
            text, lang, mac, token, speed, pitch, volumn, person))
    if r.headers.get("content-type") == "audio/mp3":
        print("Success.")
        fw = open(os.getcwd() + "/tts.mp3", "wb")
        fw.write(r.content)
        fw.close()







if __name__ == '__main__':
    #signal.signal(signal.SIGINT, ctrlc_quit)
    #while (True):
    words = "you look happy! let us listen to some music"
    if words == '/quit':
            print("Quiting...")
            sys.exit(0)
    get_baidu_voice(words, person=4)
    #playsound('tts.mp3')
