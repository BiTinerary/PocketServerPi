import smtplib

lines = [line.rstrip('\n') for line in open('/home/stuxnet/reedSwitch/gmailCreds.txt', 'r')]
#One liner for openning/reading each line of a hardcoded directory and .txt file.

def emailCreds(): #Assign each line it's own variable, which correspond to email, password, and cell phone email address.
  gmailAddress = lines[0] #In.
  gmailPass = lines[1] #That.
  toMyPhone = lines[2] #Order.
  return [gmailAddress, gmailPass, toMyPhone] #Return these variables as array.

def sendEmail(emailContent): #Take an arguement as input. This argument will be the messages content.
  gmailAddress, gmailPass, toMyPhone = emailCreds() # little uneccesary but bite me. (Re?)Assign string variables to each index
  emailContent = """Subject: %s""" % emailContent #"Subject:" is internally recognized by sendmail() (line 19)
  
  try: # exception if fail to send, connect, login, etc..
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login(gmailAddress, gmailPass) #Login credentials
    server.sendmail(gmailAddress, toMyPhone, emailContent) #send... (from, to, message)
    server.close()
    print 'Email sent!'
    
  except:
    print 'Something went wrong...' #debug
