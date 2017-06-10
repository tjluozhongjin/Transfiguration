# Isolated Word Recognition

>  Report for Lab 3, Human-Computer Interaction by Dr. Ying SHEN
>
>  Yang LI(1452669)
>
>  Open Sourced on [GitHub](https://github.com/zjzsliyang/Transfiguration) under MIT License

## Requirement

- Run SpeechRecognition-hmm
- Train another HMM using your own speech/words and modify GUI accordingly.
- Add a new fuction: Record test audios using Stat/End button
- Save training/test audios in different subdirectories

## How to Run

- initTrainData.m
- main.m
- GUI

## Tutorial

### Run the Demo

I run the ``main.m`` file to train Hidden Markov Model(HMM), and the results are as follows:

|  Word   | Iterations No. | Convergence |
| :-----: | :------------: | :---------: |
|   开始    |       34       |      Y      |
|   结束    |       29       |      Y      |
|   匿名    |       10       |      Y      |
|   标注    |       25       |      Y      |
|   词典    |       17       |      Y      |
|   打开    |       19       |      Y      |
|   孤立    |       24       |      Y      |
|   快速    |       21       |      Y      |
|   录音    |       21       |      Y      |
|   慢速    |       16       |      Y      |
|   启动    |       12       |      Y      |
|   声学    |       14       |      Y      |
|   输出    |       11       |      Y      |
|   特征    |       24       |      Y      |
|   训练    |       23       |      Y      |
|   正转    |       28       |      Y      |
| 飞流直下三千尺 |       19       |      Y      |
| 不如自挂东南枝 |       33       |      Y      |

Since all words' training has been convergenced, I started record the words and test the recognition. However, the accuracy is pretty low, about only 50%.(I tested every word once, and "开始", "标注", "孤立", "快速", "启动", "声学", "输出", "特征", "训练" have been recognized.)

### Train another HMM

To train another HMM using my own speech/words, since I want to know whether the low accuracy above due to the different person, e.g. South Chinese did not used to velar nasal. I still want to record the same words as shown in the stage 1.

``createSample.m`` file record 10 samples for every words and save as wav format, which code as follows:

```matlab
for i = 1:18
    for j = 1:10
        recObj = audiorecorder;
        disp('Start speaking.')
        recordblocking(recObj, 2);
        disp('End of Recording.');
    
        play(recObj);
        myRecording = getaudiodata(recObj);
        plot(myRecording);
    
        audiowrite(strcat(int2str(i),'_',int2str(k),'.wav'), myRecording, recObj.SampleRate);
    end
end
```

------

``initTrainData.m`` file reads the audio to generate matrix which has 18 cells, and every cell contains 9 arrays representing the every record audio wave. To reductice dimensionality, ``y(y==0) = []`` delete all the silence part.

Note that I take first 9 to train, and leave the last one to test.

```matlab
msamples = {};
for i = 1:18
    sample = cell(1,9);
    for j = 1:9
        [y fs] = audioread(strcat(int2str(i),'_',int2str(j),'.wav'));
        y(y==0) = [];
        sample{j} = y;
    end
end
```

------

Modify the ``main.m`` file as follows to train my own HMM.

```matlab
samples = msamples;
for i=1:length(samples)
	sample=[];
	for k=1:length(samples{i})
		sample(k).wave=samples{i}{k};
		sample(k).data=[];
	end
	hmm{i}=train(sample,[3 3 3 3]);
end
save('myhmm.mat','hmm');
```

------

Just replace ``testhmm.mat`` with ``myhmm.mat``.

```matlab
hmm = load('myhmm.mat');
% hmm = load('testhmm.mat');
```

The results are shown as follows:

|  Word   | Iterations No. | Convergence | Identify |
| :-----: | :------------: | :---------: | :------: |
|   开始    |       18       |      Y      |    Y     |
|   结束    |       33       |      Y      |    Y     |
|   匿名    |       13       |      Y      |    N     |
|   标注    |       6        |      Y      |    Y     |
|   词典    |       14       |      Y      |    Y     |
|   打开    |       27       |      Y      |    Y     |
|   孤立    |       ∞        |      N      |    Y     |
|   快速    |       31       |      Y      |    Y     |
|   录音    |       38       |      Y      |    Y     |
|   慢速    |       10       |      Y      |    Y     |
|   启动    |       23       |      Y      |    Y     |
|   声学    |       13       |      Y      |    Y     |
|   输出    |       ∞        |      N      |    Y     |
|   特征    |       17       |      Y      |    Y     |
|   训练    |       16       |      Y      |    Y     |
|   正转    |       30       |      Y      |    Y     |
| 飞流直下三千尺 |       30       |      Y      |    Y     |
| 不如自挂东南枝 |       22       |      Y      |    Y     |

> mark Iterations times larger than 40 as inf

As you can see, the accuracy reach 94.4%. It is pretty satisfied, but you can also add the number of Gaussian function or replace GMM by neural network(DNN, CNN) to improve further.

------

Analyze the impact of different number of HMM states on recognition accuracy, for example, change ``train(sample,[3 3 3 3])`` with ``train(sample,[5 5 5 5])``.

The comparison is shown below:

|   Word   | Identify Before | Identify After |
| :------: | :-------------: | :------------: |
|    开始    |        Y        |       Y        |
|    结束    |        Y        |       Y        |
|    匿名    |        N        |       N        |
|    标注    |        Y        |       Y        |
|    词典    |        Y        |       Y        |
|    打开    |        Y        |       Y        |
|    孤立    |        Y        |       Y        |
|    快速    |        Y        |       Y        |
|    录音    |        Y        |       Y        |
|    慢速    |        Y        |       Y        |
|    启动    |        Y        |       Y        |
|    声学    |        Y        |       Y        |
|    输出    |        Y        |       N        |
|    特征    |        Y        |       Y        |
|    训练    |        Y        |       Y        |
|    正转    |        Y        |       Y        |
| 飞流直下三千尺  |        Y        |       N        |
| 不如自挂东南枝  |        Y        |       N        |
| Accuracy |      94.4%      |     77.8%      |

------

add new fuction to record test audio using Start/End button:

```matlab
% --- Executes on button press in Start.
function pushbutton3_Callback(hObject, eventdata, handles)
global recObj;
recObj = audiorecorder;
disp('Start speaking.')
record(recObj);

% --- Executes on button press in End.
function pushbutton4_Callback(hObject, eventdata, handles)
global recObj;
stop(recObj);
disp('End of Recording.');
play(recObj);
myRecording = getaudiodata(recObj);
plot(myRecording);
audiowrite('mySpeech.wav',myRecording, recObj.SampleRate);
```

## Reference

[1] L.R.Rabiner, [A tutorial on hidden Markov models and selected applications in speech recognition](http://ieeexplore.ieee.org/abstract/document/18626/), IEEE, 1989.

[2] L. Rabiner, B. Juang, [An introduction to hidden Markov models](http://ieeexplore.ieee.org/abstract/document/1165342/), IEEE, 1986.