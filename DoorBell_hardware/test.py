import thread

import tts


def test():
    for i in range(0,20):
        print 1
    thread.exit()

thread.start_new_thread(test,())
for i in range(0,100):
    print 2
