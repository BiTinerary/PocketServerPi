#!/bin/python
import time, datetime
from sendSMSViaGmail import sendEmail #importing a personalized, custom script.
from pyA20.gpio import gpio
from pyA20.gpio import port

def initiatePin(): #Enable various functions and config for spefic GPIO on NanoPiNeoAir

	gpio.init()# Must be passed first before any other functions from GPIO library.

	gpio.setcfg(port.PA6, gpio.OUTPUT)
	gpio.input(port.PA6)

	gpio.setcfg(port.PA6, 0) #Same as above, for some reason GPIO doesn't work or setup correctly if not done like this verbatim.
	gpio.pullup(port.PA6, 0) #Clear pullups
	gpio.pullup(port.PA6, gpio.PULLDOWN) #Enable pull-down
	gpio.pullup(port.PA6, gpio.PULLUP) #Enable pull-up

def doorState(): #Get the state of the door's reed switch.
	doorStateValue = gpio.input(port.PA6) #input() is current state (High/Low) of GPIO
	if doorStateValue == 0:
		doorStateString = 'Closed'
	elif doorStateValue == 1:
		doorStateString = "Open"
	return doorStateValue, doorStateString # Return tuple. One boolean, one string.

def sendAlert():
	getTimeStamp = datetime.datetime.now().strftime('%H:%M:%S %m-%d-%Y')# timestamp. concatenated string of current time and date
	alertMessage = "Door Opened: %s" % getTimeStamp
	print alertMessage
	sendEmail(alertMessage) #pass "alertMessage" as argument to sendEmail. Which is an imported function from another script...
	time.sleep(120) # This ^ uses smptlib library to send a message, from my gmail account to the email address of my cell number.

	
initiatePin() #start of script
while True: #Initiate loop
	time.sleep(2) 
	print "Door is: %s" % doorState()[1]
	print "Door Value: %s" % doorState()[0]
	
	if doorState()[0] == 0:
		pass
	elif doorState()[0] == 1:
		sendAlert()
	print "\n"
