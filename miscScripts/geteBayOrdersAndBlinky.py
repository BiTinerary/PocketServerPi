from ebaysdk.trading import Connection as Trading
from ebaysdk.exception import ConnectionError
import bs4 as bs
import time, os

os.system('echo 0 >/sys/class/leds/blue_led/brightness') # Blue LED 'heartbeats' by default on startup, turn that *ish off.

def geteBayUnshippedOrders():
	try:
		api = Trading(config_file="ebay.yaml") # eBay API Credentials, Trading.
		response = api.execute('GetSellerTransactions', {}) # Make API call for Transactions (defaults to some date?)
		theGoods = response.content 
		return theGoods # return eBay's xml response so other functions can use it as var.
	except ConnectionError as e: # If script can't connect to internet/API, spit error.
		print(e)
		print(e.response.dict())

def getParsedOrderInfo(): 
	xmlToParseFromEbay = str(geteBayUnshippedOrders()) # Stored xml as string, as different var.
	soup = bs.BeautifulSoup(xmlToParseFromEbay, 'lxml') # Beautiful soup to parse out xml dictionarys.
	tArray = soup.transactionarray # get only the transaction data, amongst all other eBay responses.
	x = 0 # typcical counter
	for each in tArray: # for each entry in transaction array.
		shipTime = each.shippedtime # get shipped time of transaction, if item hasn't been shipped, it won't have an entry/index.
		if shipTime == None: # As mentioned above, if shipped time doesn't exist then an order needs to be shipped.
			x += 1 # If no ship time, for each item in list of transaction, count up the counter.
			return int(x) # return total number of items that need shipping.
		else:
			return int(x)

def blinkyLED(): # Blinki on board LED function
	time.sleep(.2)
	os.system('echo 1 >/sys/class/leds/blue_led/brightness')
	time.sleep(.2)	
	os.system('echo 0 >/sys/class/leds/blue_led/brightness')

def howManyTimesDoBlinky(q): # takes input which will run blink LED func.
	for i in range(q): # do the following task, 'q' amount of times.
		blinkyLED()

while True: # Main loop
	time.sleep(1200) # sleep 20 minutes (Needs to be at least 15-20 minutes as to not exceed daily API call [5000] limit)
	n = getParsedOrderInfo()
	for times in range(2400): # 2400 because that's how many times .4 seconds fits, into 20 minutes. (.4 for total runtime of blinkyLED())
		howManyTimesDoBlinky(n) # blinky LED for each order that needs shipping. WITHOUT making an API call everytime within 10 minute span.
		time.sleep(3)