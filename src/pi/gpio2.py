#!venv/bin/python
import pigpio
import time
import sys
import select

pi = pigpio.pi()  # Connect to local pigpio daemon

if not pi.connected:
    exit(0)

LED = 26
BTN = 21
pi.set_mode(LED, pigpio.OUTPUT)
pi.set_mode(BTN, pigpio.INPUT)
pi.set_pull_up_down(BTN, pigpio.PUD_DOWN)

on = True
try:
  while True:
    t = 0.5
    on = not on
    btn_pressed = pi.read(BTN)
    if btn_pressed:
      print("button pressed")
      on = True
      t = 5
    else:
      dr, _, _ = select.select([sys.stdin], [], [], 0)
      if dr:
        c = sys.stdin.read(1)  # consume 1 char
        print(f"'{c}' Key pressed")
        if c=='q':
          print("exit")
          break
        elif c=='1':
          on = True
        elif c=='0':
          on = False
        elif c=='2':
          t = 2
        else:
          print("nothing pressed")

    pi.write(LED,on)
    time.sleep(t)

except KeyboardInterrupt:
    pi.stop()
