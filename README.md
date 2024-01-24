<h1> USBTesla</h1>

A simple and quick way to create a wifi usb drive using a Raspberry Pi SBC to easily change your boombox and lockchime sounds over your home network via the browser.

<h2>But wait, why ??</h2>

Tesla recent holiday update allows you to change the sound your car makes when you lock it, this is called the Lock chime. In order to change the sound you need to plug in a USB Drive to your car and have a file called LockChime.wav on the root of your USB.

For vehicles equipmed with the Pedestrian Warning Sound Tesla allows you to change the sound of your Horn. This can be used to play any sound (to the outside) via the external loudspeaker.

All you need to play your own sounds is a USB stick. This can be a "retrofitted" one (IMPORTANT The USB stick must be formatted in ExFAT format), but also the original USB stick supplied by Tesla, which is located in the glove compartment.

But who wants to keep bringing the USB drive inside to change these sounds ? :)

This is really just a script that automates the process to create the USB Drive that can be accessed via your browser. After the instalation is complete you can access the files by poiting your browser to http://USBTesla.local 

<h2>Requirements:</h2>

1x Raspberry Pi Zero
1x MicroSD card of appropriate for the size of the USB device you want to create.
1x Power AND Data cable to connect the Raspberry Pi to your Tesla.

<h2>Credits:</h2>

FileBrowser is a simple, easy to use web interface for file management. https://github.com/filebrowser/filebrowser

MagPi, the official raspberry pi magazine, in particular this article https://magpi.raspberrypi.com/articles/pi-zero-w-smart-usb-flash-drive

