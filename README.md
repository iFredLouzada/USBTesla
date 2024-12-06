<h1> USBTesla</h1>

A simple and quick way to create a wifi usb drive using a Raspberry Pi SBC to easily change your boombox and lockchime sounds over your home network via the browser.

<h2>A holiday update feature</h2>

<p>Tesla's 2023 Holiday update allows you to change the lock chime sound of your car makes when you lock it, this is called the Lock chime. In order to change the sound you need to plug in a USB Drive to your car and have a file called LockChime.wav on the root of your USB.</p>
<p>For vehicles equipmed with the Pedestrian Warning Sound Tesla allows you to change the sound of your Horn. This can be used to play any sound (to the outside) via the external loudspeaker.</p>
<p>All you need to play your own sounds is a USB stick. This can be a "retrofitted" one (IMPORTANT The USB stick must be formatted in ExFAT format), but also the original USB stick supplied by Tesla, which is located in the glove compartment.</p>

<h2>But who wants to keep bringing the USB drive inside to change these sounds?</h2>

<p>This is USBTesla. Just a script that automates the process to create the USB Drive that can be accessed via your browser. After the instalation is complete you can access the files by poiting your browser to http://USBTesla.local </p>

<h2>Requirements:</h2>

<p>1x Raspberry Pi Zero</p>
<p>1x MicroSD card of at least 32Gb. This script will ask you to choose between 4Gb, 8Gb or 16Gb</p>
<p>1x Power AND Data cable to connect the Raspberry Pi to your Tesla.</p>

<h2> Installation instructions</h2>

<p>There are two steps you'll need to complete before installing USBTesla.</p>

Step 1: [Prepare your Raspberry Pi Zero](https://github.com/iFredLouzada/USBTesla/wiki/Preparing-the-hardware)

Step 2: [Connect to your Raspberry Pi Zero](https://github.com/iFredLouzada/USBTesla/wiki/Connect-to-the-Raspberry-Pi)


<p>After these two steps, just run the following command from your Pi</p>
<code>bash -c "$(curl -fsSL https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/USBTesla_setup.sh)"</code>

<h2>Credits:</h2>

<p>FileBrowser is a simple, easy to use web interface for file management. https://github.com/filebrowser/filebrowser</p>
<p>MagPi, the official raspberry pi magazine, in particular this article https://magpi.raspberrypi.com/articles/pi-zero-w-smart-usb-flash-drive</p>


