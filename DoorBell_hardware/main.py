import keypad
import time
import takePhoto
import deal
import threading
import time
import requests
import stepMotor
import postUnLock
import postConfidence
kp = keypad.keypad()

global flag
flag = False #flag some open method in proccess

mutex = threading.Lock()

global t
t = False

def faceOrKeyOpen():
    global flag,mutex
    #time.sleep(1)
    while True:
        digit = None
        while digit == None:
            digit = kp.getKey()
        #print digit
        #face
        if digit == 1 or digit == 2 or digit == 3 or digit == 'A':
            if mutex.acquire(1):
                flag = True
                takePhoto.take()
                photo1 = '/home/pi/face.jpg'
                photo2 = '/home/pi/teamCognitive/IMG_3546.jpg'
                deal.deal_back(photo1,photo2)
                flag = False
                mutex.release()
        #keyc
        elif digit == 4 or digit == 5 or digit == 6 or digit == 'B':
            if mutex.acquire(1):
                flag = True
                print 'open'
                flag = False
                mutex.release()
        time.sleep(0.5)
    #thread.exit()

def fingerUnlock():
    global flag,mutex
    while True:
        res = requests.get("http://60.205.206.174:3000/getUnlock")
        #res = requests.get('http://10.0.1.12:3000/getUnlock')
        print res.text
        if res.text == 'true':
            if mutex.acquire(1):
                flag = True
                stepMotor.setup()
                stepMotor.backward(0.002, 256)
                time.sleep(2)
                stepMotor.forward(0.002, 256)
                postUnLock.postLock()
                flag = False
                mutex.release()
        time.sleep(0.5)
        

def phone():
    while True: 
        if t:
            print 'open'
        time.sleep(1)

if __name__ == '__main__':
    
    #t1 = threading.Thread(target=faceOrKeyOpen,args=())
    #t1.setDaemon(True)
    #t1.start()
    #t2 = threading.Thread(target=fingerUnlock,args=())
    #t2.setDaemon(True)
    #t2.start()
    #thread.start_new_thread(phone,())
    #stepMotor.setup()
    #stepMotor.backward(0.002, 256)

    #fingerUnlock()
    faceOrKeyOpen()
    '''
    while True:
        digit = None
        while digit == None:
            digit = kp.getKey()
        #print digit
        #face
        if digit == 1 or digit == 2 or digit == 3 or digit == 'A':
            flag = True
            takePhoto.take()
            photo1 = '/home/pi/face.jpg'
            photo2 = '/home/pi/teamCognitive/IMG_3546.jpg'
            deal.deal_back(photo1,photo2)
            flag = False
            
        #key
        elif digit == 4 or digit == 5 or digit == 6 or digit == 'B':
            flag = True
            print 'open'
            flag = False
        time.sleep(0.5)

     '''
