import thread
import time
import ourCompare
import ourAnalyze
#from playsound import playsound
import photoPost
import os
import tts
import stepMotor
import postConfidence
#face_token = ''
#confidence = ''
def thread_post_photo(imagefile):
    photoPost.post(imagefile=imagefile)
    thread.exit()



def play_audio(audioFile):
    #playsound(audioFile)
    os.system("mpg123 %s"%audioFile)
    thread.exit()

def text_to_speech(words):
    tts.get_baidu_voice(words)
    thread.start_new_thread(play_audio,('tts.mp3',))
    #play_audio('1.mp3')

def deal_emotion(emotionJson):
    print emotionJson['happiness']

def motor():
    stepMotor.setup()
    stepMotor.backward(0.002, 256)
    time.sleep(2)
    stepMotor.forward(0.002, 256)
    print "motor"
    #stepMotor.destroy()
    
def deal_host(face_token):
    #motor go
    motor()
    #welcom2 back
    s = "welcome back"
    text_to_speech(s)

    #emotion to music
    analyzeApiJson = ourAnalyze.analyze(face_token=face_token)
    if not analyzeApiJson['faces']:
        print 'no emotion'
    else:
        deal_emotion(analyzeApiJson['faces'][0]['attributes']['emotion'])

def deal_no_host():
    s = "You are not authorized , please contact Host Family"
    text_to_speech(s)
    print s

def deal_go():
    s1 = "It's going to rain today.Don't forget taking your umbrella."
    s2 = "And don't forget to pick up your girlfriend"
    s = s1 + s2
    #ourSpeech.get_speech_values(s)

def deal_back(photo1,photo2):
    #take a photo,we have to change this
    #photo = '/Users/luozhongjin/Desktop/IMG_3546.jpg'



    #photo1 = '/home/pi/teamCognitive/IMG_3546.jpg'
    #photo2 = '/home/pi/teamCognitive/IMG_3546.jpg'

    #thread.start_new_thread(thread_post_photo,(photo1,))

    name = -1
    confidence=0
    for i in range(0,3):
        photo2 =  '/home/pi/hci/306/%s.jpg'%i       
        compareApiJson = ourCompare.compare(imageFile1=photo1,imageFile2=photo2)
        if not compareApiJson['faces1']:
            print "error"
        else:
            face_token = compareApiJson['faces1'][0]['face_token']
            confidence = compareApiJson['confidence']
            #print face_token,confidence
            print confidence
            if confidence > 70.0:
                #deal_host(face_token=face_token)
                name = i
                break;
            else:
                #deal_no_host()
                pass
            
    if name == -1:
        deal_no_host()
        postConfidence.postConfidence(confidence)
        photoPost.post(photo1)
    else:
        deal_host(face_token=face_token)
        postConfidence.postConfidence(confidence)
        photoPost.post(photo1)

    
    # #get a faceId
    # faceID = ""
    # faceApiJson = ourFace.get_face_values(photo)
    # if not faceApiJson:
    #     print ("no face detected")
    # else:#if detect a face
    #     for i in faceApiJson:
    #         faceID = i['faceId']
    #         print (faceID)
    #         break;#just detect one person
    #     # compare with images in database using faceID
    #     confidence = 0
    #     compareApiJson = ourCompare.get_compare_value(faceID)
    #     if not compareApiJson:
    #         #post a stranger person photo
    #         #photoPost.photo_post(photo)
    #         print ("error")
    #     else:#if similar
    #         for j in compareApiJson:
    #             confidence = j["confidence"]
    #             print confidence
    #             break
    #
    #     #speech
    #     if confidence > 0.7:
    #         s = "welcome back!!"
    #         #os.system("say %s"% s)
    #
    #         emotionValue=""
    #         emotionApiJson = ourEmotion.get_emotional_values(photo)
    #         emotionValue = deal_emotion(emotionApiJson)
    #         #s = s + 'let us,,listening , a  music!'
    #         #os.system("say %s" % s)
    #         if emotionValue > 0.7:
    #             s = s + "you look happy, let us listen to some music!"
    #             ourSpeech.get_speech_values(s)
    #             #os.system("say %s" % s)
    #             #playsound("happy.wav")
    #         else:
    #             s = s + "you look sad, let us listen to some joke!"
    #             #ourSpeech.get_speech_values(s)
    #             os.system("say %s" % s)
    #             #playsound("sad.wav")
    #     else:
    #         s = "You are not authorized , please contact Host Family"
    #         #ourSpeech.get_speech_values(s)
    #         os.system("say %s" % s)
if __name__ == '__main__':
    photo1 = '/home/pi/teamCognitive/IMG_3546.jpg'
    photo2 = '/home/pi/teamCognitive/IMG_3546.jpg'
    deal_back(photo1,photo2)
