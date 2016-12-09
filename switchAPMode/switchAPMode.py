import os, time, socket

os.system('turn-wifi-into-apmode no')
onlineArray = []
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
		
	if onlineArray == ['False', 'False', 'False']:
		os.system('turn-wifi-into-apmode yes')
		break
	elif onlineArray != ['False','False','False']:
		pass
	
	onlineArray = []
