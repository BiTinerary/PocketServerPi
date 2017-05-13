#!/bin/python
import time, datetime
from sendSMSViaGmail import sendEmail
from pyA20.gpio import gpio
from pyA20.gpio import port

def initiatePin():

	gpio.init()

	gpio.setcfg(port.PA6, gpio.OUTPUT)
	gpio.input(port.PA6)

	gpio.setcfg(port.PA6, 0) #Same as above
	gpio.pullup(port.PA6, 0) #Clear pullups
	gpio.pullup(port.PA6, gpio.PULLDOWN) #Enable pull-down
	gpio.pullup(port.PA6, gpio.PULLUP) #Enable pull-up

def doorState():
	doorStateValue = gpio.input(port.PA6)
	if doorStateValue == 0:
		doorStateString = 'Closed'
	elif doorStateValue == 1:
		doorStateString = "Open"

	return doorStateValue, doorStateString

def sendAlert():
	getTimeStamp = datetime.datetime.now().strftime('%H:%M:%S %m-%d-%Y') 
	alertMessage = "Door Opened: %s" % getTimeStamp
	print alertMessage
	sendEmail(alertMessage)
	time.sleep(300)

initiatePin()

while True:
	time.sleep(2)
	print "Door is: %s" % doorState()[1]
	print "Door Value: %s" % doorState()[0]
	
	if doorState()[0] == 0:
		pass
	
	elif doorState()[0] == 1:
		sendAlert()
	
	print "\n"
