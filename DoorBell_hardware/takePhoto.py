from picamera import PiCamera
import time

def take():
    camera = PiCamera()
    camera.start_preview()
    camera.rotation = 90
    time.sleep(2)
    camera.capture("/home/pi/face.jpg")
    camera.stop_preview()
    camera.close()
    
    print "taked"


if __name__ == "__main__":
    take()
