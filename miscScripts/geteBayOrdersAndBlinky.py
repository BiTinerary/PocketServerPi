
from ebaysdk.trading import Connection as Trading
from ebaysdk.exception import ConnectionError
import bs4 as bs
import time, os

os.system('echo 0 >/sys/class/leds/blue_led/brightness') # Nano pi will 'heartbeat' led on startup, stop that *ish.
time.sleep(30) # My auto client/AP mode script causes slight delay in internet connection, don't error out on first try/except

def geteBayUnshippedOrders():
        try:
                api = Trading(config_file="/home/stuxnet/blinkPerOrder/ebay.yaml") # eBay API Credentials, Trading.
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
                        print('nuffin')
                        pass

def blinkyLED(): # Blink on board LED function
        os.system('echo 0 >/sys/class/leds/blue_led/brightness')
        time.sleep(.2)
        os.system('echo 1 >/sys/class/leds/blue_led/brightness')
        time.sleep(.2)
        os.system('echo 0 >/sys/class/leds/blue_led/brightness')
        print('blinky LED')

def howManyTimesDoBlinky(q): # takes input which will run blink LED func.
        for i in range(q): # do the following task, 'q' amount of times.
                blinkyLED()
                print('Led Blink: %s' %s)

while True: # Main loop
        n = getParsedOrderInfo()
        for times in range(36): # because that's how many times 3.4 seconds fits, into 2 minutes. (.4 for total runtime of blinkyLED()+ 3 sec wait in between)
                try: # try to find orders and run blinky
                        howManyTimesDoBlinky(n) # blinky LED for each order that needs shipping. WITHOUT making an API call everytime within 10 minute span.
                        print('Orders Need Shipping!')
                        time.sleep(3)
                except: # If no orders need to be shipped, `None` is passed to blinky (not integer), so manually sleep 120 seconds as to not pilfer through API call limit.
                        time.sleep(120)
                        print('Pretend sleep...')
                        pass
