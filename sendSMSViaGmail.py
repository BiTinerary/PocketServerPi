import smtplib, sys

#subject = sys.argv[1]

lines = [line.rstrip('\n') for line in open('/home/stuxnet/reedSwitch/gmailCreds.txt', 'r')]

def emailCreds():
  gmailAddress = lines[0]
  gmailPass = lines[1]
  toMyPhone = lines[2]
  return [gmailAddress, gmailPass, toMyPhone]

def sendEmail(emailContent):
  gmailAddress, gmailPass, toMyPhone = emailCreds()
  emailContent = """Subject: %s""" % emailContent #(subject.split(',')[0], subject.split(',')[1])
  try:
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login(gmailAddress, gmailPass)
    server.sendmail(gmailAddress, toMyPhone, emailContent)
    server.close()
    print 'Email sent!'
    
  except:
    print 'Something went wrong...'
