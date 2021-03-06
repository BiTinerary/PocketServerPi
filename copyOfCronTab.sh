
# Edit this file to introduce tasks to be run by cron.
#
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
#
# For more information see the manual pages of crontab(5) and cron(8)
#
#
# m h  dom mon dow   command
#@reboot /usr/bin/python2.7 /usr/local/bin/butterfly.server.py --host="0.0.0.0" --port=57575 --unsecure
#@reboot /usr/bin/python2.7 /home/stuxnet/blinkPerOrder/blinkPerOrder.py >/home/stuxnet/switchAPMode/Logs/cronlog 2>&1
# ^^ Working ^^, but not installed, being used anymore or replaced by another technique
@reboot /usr/bin/python2.7 /home/stuxnet/samba/luma.examples-master/examples/sys_info.py --display ssd1306 --rotate 2 --interface i2c --i2c-port 0
@reboot bash /home/stuxnet/PocketServerPi/noVNCAutoInstallation.sh
