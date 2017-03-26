# Installing requirements for RM-Hulls Screen repo on Armbian kernel
# https://github.com/rm-hull/luma.oled

# Some development tools are needed
sudo su
apt-get install python-dev python-setuptools libjpeg-dev

# The modules/libraries included in his repo use Pillow for the OLED screens.
# If you don't have pip installed (not included in Armbian by default) then...
apt-get install python-pip
pip install pillow

# At one point of an installation I was prompted with error codes, that the following python modules weren't included so I ran...
pip install image
pip install mock
pip install smbus2

# Debug. Still getting pillow import error codes?
pip uninstall pillow
pip install pillow==2.9.0
