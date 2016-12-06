#!/bin/python

import os, time, socket

onlineArray = []

os.system('turn-wifi-into-apmode no')
time.sleep(5)

def amIOnline():
	try:
		host = socket.gethostbyname("www.google.com")
		s = socket.create_connection((host, 80), 2)
		onlineArray.append('True')
	except:
		onlineArray.append('False')
	time.sleep(10)

while True:
	for x in range(3):
		amIOnline()
		print onlineArray

	if onlineArray == ['False', 'False', 'False']:
		os.system('turn-wifi-into-apmode yes')
		break

	elif onlineArray != ['False','False','False']:
		pass

	onlineArray = []
