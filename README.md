# Transfiguration
42034502 Spring2017 Human-Computer Interaction Project by Dr. [Ying SHEN](mailto:yingshen@tongji.edu.cn) @ SSE, TJU

## Bella Bell

an smart bell for IoT and smart home supporting iOS platform to controll your door and remind you with calendar and to-do list.

![iOS](https://img.shields.io/badge/iOS-10.3-brightgreen.svg) ![Swift](https://img.shields.io/badge/Swift-3-blue.svg) ![Node](https://img.shields.io/badge/Node-8.0.0-orange.svg) ![license](https://img.shields.io/badge/License-MIT-lightgrey.svg)

### How to Run

Just download the DoorBell from App Store, and run it!

or manually:

- Front-end
  - Install third-party frameworks via CocoaPods
  - Build the ``DoorBell.xcworkspace`` file

- Back-end
  - Install node modules via npm
  - Start the server via forever

### Functionality 

- Unlock
  - unlock door with Face Recognition
  - unlock door with touchID
  - unlock door with QR Code
- Alert
  - Send Notification while meeting strangers
  - Chose to unlock or refuse while meeting strangers
- Agenda
  - Access your calendar and remind you when you leave
- Family
  - Notify when your following people leave or come in
  - Show the people in dormitory(home) in real time

### Implemented Requirements



### Structures & Modules

brief introduction 

#### Front-end

#### Back-end

#### Cognitive Services

As we can see as follow, the whole architecture include Raspberry PI, Camera, Cognitive Services, Electrical Machine, Voice Box and Door. The Raspberry PI control the camera, when someone take a photo using camera, the Raspberry PI will send photo to Face Recognition (detect & Compare) and send to emotion recognition.Then, The Face Recognition will inform Electrical Machine to open door, and the Emotion Recognition will inform Voice Box to play audio.

![architecture](/Users/luozhongjin/Transfiguration/photo/architecture.png)

##### Opening Door Using Face

In Bella Bell, the **first lightspot** is that we can open our room door using face. To achieve this, what we do as follows :

- Face Detect
- Face Compare

###### Face Detect

In order to open room door using face, we need to stored all our roommate's photos in database and  detect the face of these photos to get **FaceID Aarry** which represent the face of different photos and will be used in Face Compare. Then, we will capture a new photo using camera when someone want to open door using face, and the new photo also need to get **FaceID** which will be also used in Face Compare. To achieve this, we need to call cognitive services API. The first time we using Microsoft Cognitive Services, because it is more authoritative. Code as follow: 

```
......
def get_face_values(file_location):
	url = 'https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect'
	key = 'ca99486b8b8744ba96d756e105c8275c'
	data = open(file_location, 'rb').read()
	headers = {
		'Ocp-Apim-Subscription-Key':key,
		'Content-Type': 'application/octet-stream'
		}
	return requests.request("POST", url=url, data=data, headers=headers).json()
......
```

But in the beta phase, when we try to using face to open our door, we found that the dectect process is so slow, which make us wait for a long time to get the door open, it make us impatient. After analyzing, we found that it is because that Microsoft server set up in foreign countries, which make the dectect process slow. So, we changed to use Face++ Cognitive Services whose server is in China. Code as follows:

```
......
def detect(imageFile):
    key = "LiRb3yg8xNdZ26KaaGWpBvocRntnNVpy"
    secret = "sfzfdDGKizGtGy9l-1c6-Yys9lz1Etmq"
	url = "https://api-cn.faceplusplus.com/facepp/v3/detect"
    file = open(imageFile,'rb').read()
    files = {
        #'Content-Type': 'multipart/form-data',
        'image_file' : file
    }
    params = {
        'api_key': key,
        'api_secret': secret,
        'return_attributes':'emotion'
    }
    res=requests.post(url,params=params,files=files).json()
    print res
......
```

After changing , we found that the speed of Face Detect improve visibly, which make us no longer impatient.

###### Face Compare

After Face Dectect, the next step is comparing the photo capture from camera with photos stored in the database. To achieve this, we need to post FaceID one (represent the photo from camera) and FaceID two(represent one of photos stored in the database), then we will get the similarity back. Our rule is that if the similarity is greater than 70.0%, the door will open. Code using Microsoft Services as follow:

```
......
def get_compare_value(id1):
    headers = {
    'Content-Type': 'application/json',
    'Ocp-Apim-Subscription-Key': 'ca99486b8b8744ba96d756e105c8275c',
    }
    id2 = '815a7784-676a-43aa-a215-beb7b1230760'
    body = {'faceId': id1, 'faceIds': [id2]}

    conn = httplib.HTTPSConnection('westcentralus.api.cognitive.microsoft.com')
    conn.request("POST", "/face/v1.0/findsimilars?%s" % params, json.dumps(body), headers)
    response = conn.getresponse()
    data = response.read()
    dataJson = json.loads(data)
    return (dataJson)
......
```

As same as Face Detect Process, we change to use Face++ Cognitive Services later to compare face. Code as follow:

```
......
def compare(face_token1,face_token2):
    url = 'https://api-cn.faceplusplus.com/facepp/v3/compare'
    params = {
        'api_key': 'LiRb3yg8xNdZ26KaaGWpBvocRntnNVpy',
        'api_secret': 'sfzfdDGKizGtGy9l-1c6-Yys9lz1Etmq',
        'face_token1':	face_token1,
        'face_token2':	face_token2
    }
    a = time.time()
    r = requests.post(url, params=params,files=files)
    b = time.time()
    j = r.json()
    return j
......
```

But afterwards, we found that the time of posting  one photo to Face++ server and the time of posting two photo to Face++ server are little difference. Therefore, in order to ensure the reliability and persistence of our photo, and make the code more concise, we use the following code instead, this code will change the two step to one step.

```
......
def compare(imageFile1,imageFile2):
    url = 'https://api-cn.faceplusplus.com/facepp/v3/compare'
    params = {
        'api_key': 'LiRb3yg8xNdZ26KaaGWpBvocRntnNVpy',
        'api_secret': 'sfzfdDGKizGtGy9l-1c6-Yys9lz1Etmq',
    }
    file1 = open(imageFile1,'rb').read()
    file2 = open(imageFile2,'rb').read()
    files = {
        'image_file1' : file1,
        'image_file2' : file2
    }
    a = time.time()
    r = requests.post(url, params=params,files=files)
    b = time.time()
    j = r.json()
    return j
......
```

###### Main Business Logic

We have stored all of our roommate's photos in database in Raspberry PI, and in the business logic we will traverse database to compare the photos capture from camera with all the photos in database, and if similarity is greater than 70.0%, Bella Bell will regard you as host, and then will open door for you, recognize your emotion to play music for you(which will be introduce later). Logic code as follow:

```
def deal_back(photo1,photo2):
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
            print confidence
            if confidence > 70.0:
                name = i
                break;
            else:
                pass
    if name == -1:
        deal_no_host()
        postConfidence.postConfidence(confidence)
        photoPost.post(photo1)
    else:
        deal_host(face_token=face_token)
        postConfidence.postConfidence(confidence)
        photoPost.post(photo1)
def deal_host(face_token):
    motor()
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
```

##### Play Audio According To Emotion

Can you imagine? When you achieve a small goal and go back home, you hear a happy song immediately after you open the door. And when you are sad and go back, you hear a joy after you open the door. It is so warm. In our Bella Bell, the **second lightspot** is that when you open door using face, Bella Bell will recognize your emotion and play different audio for you. To achieve this, we do as follows:

- recognize emotion
- play audio

In the first step, we use Face++ Emotion API to get the emotion value, code as follow:

```
......
def analyze(face_token):
	url = 'https://api-cn.faceplusplus.com/facepp/v3/face/analyze'
    params = {
        'api_key': key,
        'api_secret': secret,
        'return_attributes':'emotion',
        'face_tokens':[face_token]
    }
    res=requests.post(url,params=params).json()
    return res
......
```

In the second step, we have the following code in the ``deal.py``:

```
......
def deal_emotion(emotionJson):
    happiness = emotionJson['happiness']
    if happiness > 10.0:
        s = 'You look happy, let us enjoy some music'
        text_to_speech(s)
        time.sleep(3.5)
        os.system("mpg123 %s"%'1.mp3')
    else:
        s = 'You look sad, let us listen some joy'
        text_to_speech(s)
        time.sleep(3.5)
        os.system('mpg123 %s'%'sad.mp3')
    print emotionJson['happiness']
......
```

##### Record Dormitory Status 

There is no doubt that sometimes we forget bringing our book when we are hurry to the classroom. Bella Bell allows you check which roommate is in the room, so that you can ask him to bring you book when he go to the classroom.Due to our roommate use the same router，that is to say our phones are in the same local area network after connecting to the network. Therefore, we use  ``ping ip``  to confirm whether someone is in the room. Code as follows:

```
......
def postPresent():
    j = 0
    for i in hostnames:
        res = os.system("ping -W 20 -s 1 -c 3 " + i)
        if res == 0:
            pass
        else:
            present[j] = 'false'
        j = j + 1
    url = 'http://60.205.206.174:3000/present'
    headers = {
        'Content-Type':'application/json'
    }
    d = {
        '0':present[0],
        '1':present[1],
        '2':present[2],
        '3':present[3]
    }
    r = requests.post(url,headers = headers,data = json.dumps(d))
......
```

#####  Other Function

In our project, there are some functional module we have achieved part of it, but due to the function are imperfect and user experience is poor, we haven't added to Bella Bell. 

###### Smart Reminder

Can you imagine? When you leave the room, Bella Bell will remind you something important, such as weather, assignment deadline and so on. Although we haven't decided how to judge that a person want to leave, we have achieve the Text To Speech module. Owing to we use Raspberry PI to control our door and the voice of text to speech native libraries of linux sounds so bad, we decide to use BaiDu Text To Speech API. Code as follow: 

```
......
def get_baidu_voice(text, lang="zh", speed=5, pitch=5, volumn=5, person=0):
	url = "http://tsn.baidu.com/text2audiotex=%s&lan=%s&cuid=%s&ctp=1&tok=%s"
			+ "&spd=%d&pit=%d&vol=%d&per=%d"
    token = get_token()
    mac = get_mac_address()
    r = requests.get(url% (text, lang, mac, token, speed, pitch, volumn, person))
    if r.headers.get("content-type") == "audio/mp3":
        print("Success.")
        fw = open(os.getcwd() + "/tts.mp3", "wb")
        fw.write(r.content)
        fw.close()
......
```

###### Speech Control

In Bella Bell, we hope that we can control Raspberry PI using voice, so that we can use voice to open the door, to instruct Bella Bell to play song and so on.  But we found that the environmental noise make this function play a bad performance,  We haven't added to Bella Bell. It need to be improved before using. Some code of this module as follow (using Microsoft Bing Speech API):

```
......
def speech_to_text():
    AUDIO_FILE = path.join(path.dirname(path.realpath(__file__)), "english.wav")
    # obtain audio from the microphone
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("Say something!")
        audio = r.listen(source)
    BING_KEY = "7e964898eaed4b8887eef9abd271ff54"
    text = r.recognize_bing(audio, key=BING_KEY)
    print("Microsoft Bing Voice Recognition thinks you said " + text)
    return text
 ......
```

#### Hardware



### Pros & Cons

- Advantages
  - ​
- Disadvantages 
  - ​

### Improvements

- Face Recognition Locally

### Under Construction

- [ ] Adapt for different models

### Contribution

- Front-end(iOS App)
  - Yang LI
- Back-end(Node.js)
  - Yang LI
- Hardware
  - Zhongjin LUO
  - Guohui YANG
- UI Design
  - Yirui WANG

### License

- Open Sourced on [GitHub](https://github.com/zjzsliyang/Transfiguration) under MIT License
- Fork & Issues are both welcomed