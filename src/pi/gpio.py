#!venv/bin/python
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
port = 26
GPIO.setup(port, GPIO.OUT)

state = True

# endless loop, on/off for 1 second
while True:
	GPIO.output(port,True)
	time.sleep(1)
	GPIO.output(port,False)
	time.sleep(1)
